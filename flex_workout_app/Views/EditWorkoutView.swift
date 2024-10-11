import SwiftUI

struct EditWorkoutView: View {
    @State private var workoutName: String
    @State private var exercises: [Exercise] = []
    let workout: Workout
    let programId: Int
    @StateObject private var viewModel: WorkoutsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isShowingExerciseSelection = false


    
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
                            try? await viewModel.deleteWorkout(_:workout)
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
                    await fetchExercises()
                }
            }
            .sheet(isPresented: $isShowingExerciseSelection) {
                ExerciseSelectionView(
                    viewModel: viewModel,
                    workout: workout,
                    onExercisesAdded: { newExercises in
                        Task {
                            try? await viewModel.addExercisesToWorkout(newExercises, workout: workout)
                            await fetchExercises()
                        }
                })
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
                            do {
                                await viewModel.updateWorkout(workout, with: workoutName)
                                try await viewModel.fetchWorkouts(for: programId)
                                await MainActor.run {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } catch {
                                print("Error updating workout: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func fetchExercises() async {
        do {
            exercises = try await viewModel.fetchProgramExercises(for: workout)
            print(exercises)
        } catch {
            print("Error fetching exercises: \(error)")
        }
    }
    
    private func removeExercises(at offsets: IndexSet) {
        Task {
            for index in offsets {
                let exercise = exercises[index]
                do {
                    try await viewModel.removeExerciseFromWorkout(exercise, workout: workout)
                } catch {
                    print("Error removing exercise: \(error)")
                }
            }
            await fetchExercises()
        }
    }
}


//struct WorkoutInfo_Previews: PreviewProvider {
//    static var previews: some View {
//        EditWorkoutView(workout: Wo, viewModel: <#T##WorkoutsViewModel#>, programId: <#T##Int#>)
//    }
//}
