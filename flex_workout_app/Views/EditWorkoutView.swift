import SwiftUI

struct EditWorkoutView: View {
    // Local state that will be pushed to backend on save
    @State private var workoutName: String
    @State private var exercises: [Exercise] = []
    @State private var exercisesToRemove: Set<Exercise> = []
    @State private var exercisesToAdd: Set<Exercise> = []
    
    // View state
    @State private var isShowingExerciseSelection = false
    @Environment(\.presentationMode) var presentationMode
    
    // Dependencies
    let workout: Workout
    let programId: Int
    @StateObject private var viewModel: WorkoutsViewModel
    
    init(workout: Workout, viewModel: WorkoutsViewModel, programId: Int) {
        self.workout = workout
        self.programId = programId
        self._viewModel = StateObject(wrappedValue: viewModel)
        _workoutName = State(initialValue: workout.workoutName)
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
                
                Section {
                    Button(action: {
                        Task {
                            try? await viewModel.deleteWorkout(workout)
                            presentationMode.wrappedValue.dismiss()
                        }
                    }) {
                        Text("Remove Workout")
                            .foregroundColor(.red)
                    }
                }
            }
            .onAppear {
                Task {
                    await loadExercises()
                }
            }
            .sheet(isPresented: $isShowingExerciseSelection) {
                ExerciseSelectionView(
                    viewModel: viewModel,
                    workout: workout,
                    onExercisesAdded: { newExercises in
                        exercises.append(contentsOf: newExercises)
                        exercisesToAdd.formUnion(newExercises)
                    }
                )
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Edit Workout")
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
                            await saveChanges()
                        }
                    }
                }
            }
        }
    }
    
    private func loadExercises() async {
        do {
            exercises = try await viewModel.fetchProgramExercises(for: workout)
        } catch {
            print("Error loading exercises: \(error)")
        }
    }
    
    private func removeExercises(at offsets: IndexSet) {
        let exercisesToDelete = offsets.map { exercises[$0] }
        exercisesToRemove.formUnion(exercisesToDelete)
        exercises.remove(atOffsets: offsets)
    }
    
    private func saveChanges() async {
        do {
            // Update workout name if changed
            if workoutName != workout.workoutName {
                await viewModel.updateWorkout(workout, with: workoutName)
            }
            
            // Remove exercises that were deleted
            for exercise in exercisesToRemove {
                try await viewModel.removeExerciseFromWorkout(exercise, workout: workout)
            }
            
            // Add new exercises
            if !exercisesToAdd.isEmpty {
                try await viewModel.addExercisesToWorkout(Array(exercisesToAdd), workout: workout)
            }
            
            // Refresh workouts list and dismiss
            _ = try await viewModel.fetchWorkouts(for: programId)
            await MainActor.run {
                presentationMode.wrappedValue.dismiss()
            }
        } catch {
            print("Error saving changes: \(error)")
        }
    }
}


//struct WorkoutInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        EditWorkoutView(workout: Wo, viewModel: <#T##WorkoutsViewModel#>, programId: <#T##Int#>)
//    }
//}
