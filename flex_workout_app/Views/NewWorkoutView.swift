import SwiftUI

struct NewWorkoutView: View {
    let programId: Int
    @StateObject private var viewModel: WorkoutsViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // Local state
    @State private var workoutName = ""
    @State private var exercises: [Exercise] = []
    @State private var isShowingExerciseSelection = false
    
    init(viewModel: WorkoutsViewModel, programId: Int) {
        self.programId = programId
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Workout Name", text: $workoutName)
                }
                
                Section(header: Text("Exercises")) {
                    ForEach(exercises) { exercise in
                        NavigationLink(destination: Text("Edit \(exercise.exerciseName)")) {
                            Text(exercise.exerciseName)
                        }
                    }
                    .onDelete(perform: removeExercises)
                    
                    Button(action: {
                        isShowingExerciseSelection = true
                    }) {
                        Text("Add Exercise")
                            .foregroundColor(.blue)
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Create Workout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            await saveWorkout()
                        }
                    }
                    .disabled(workoutName.isEmpty)
                }
            }
            .sheet(isPresented: $isShowingExerciseSelection) {
                ExerciseSelectionView(
                    viewModel: viewModel,
                    onExercisesAdded: { newExercises in
                        exercises.append(contentsOf: newExercises)
                    }
                )
            }
        }
    }
    
    private func removeExercises(at offsets: IndexSet) {
        exercises.remove(atOffsets: offsets)
    }
    
    private func saveWorkout() async {
        do {
            // First create the workout
            try await viewModel.createWorkout(workoutName: workoutName, programId: programId)
            
            // Get the newly created workout
            guard let newWorkout = viewModel.workouts.last else {
                print("Error: Couldn't find newly created workout")
                return
            }
            
            // Add all exercises to the workout
            try await viewModel.addExercisesToWorkout(exercises, workout: newWorkout)
            
            // Refresh the workouts list
            _ = try await viewModel.fetchWorkouts(for: programId)
            
            await MainActor.run {
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("Error saving workout: \(error)")
        }
    }
}

// Preview provider
struct NewWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        NewWorkoutView(viewModel: WorkoutsViewModel(), programId: 1)
    }
}
