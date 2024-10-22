import SwiftUI

struct ExerciseSelectionView: View {
    @ObservedObject var viewModel: WorkoutsViewModel
    @State private var selectedExercises: Set<Exercise> = []
    @State private var exercises: [Exercise] = []
    @Environment(\.presentationMode) var presentationMode
    
    let workout: Workout?
    let onExercisesAdded: ([Exercise]) -> Void
    
    init(viewModel: WorkoutsViewModel, workout: Workout? = nil, onExercisesAdded: @escaping ([Exercise]) -> Void) {
        self.viewModel = viewModel
        self.workout = workout
        self.onExercisesAdded = onExercisesAdded
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(exercises) { exercise in
                        SelectExerciseRow(
                            exercise: exercise,
                            isSelected: selectedExercises.contains(exercise)
                        ) {
                            toggleExerciseSelection(exercise)
                        }
                    }
                }
                
                Button(action: {
                    addExercises(Array(selectedExercises))
                }) {
                    Text("Add(\(selectedExercises.count))")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                .disabled(selectedExercises.isEmpty)
            }
            .navigationTitle("Add Exercise")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Add(\(selectedExercises.count))") {
                    addExercises(Array(selectedExercises))
                }
                .disabled(selectedExercises.isEmpty)
                .foregroundColor(.blue)
            )
        }
        .task {
            await fetchExercises()
        }
    }
    
    private func fetchExercises() async {
        do {
            exercises = try await viewModel.fetchAllExercises()
        } catch {
            print("Error fetching exercises: \(error)")
        }
    }
    
    private func toggleExerciseSelection(_ exercise: Exercise) {
        if selectedExercises.contains(exercise) {
            selectedExercises.remove(exercise)
        } else {
            selectedExercises.insert(exercise)
        }
    }
    
    private func addExercises(_ exercises: [Exercise]) {
        Task {
            do {
                // Only add to backend if we're editing an existing workout
                if let workout = workout {
                    try await viewModel.addExercisesToWorkout(exercises, workout: workout)
                }
                
                // Always call onExercisesAdded to update parent view
                onExercisesAdded(exercises)
                
                await MainActor.run {
                    presentationMode.wrappedValue.dismiss()
                }
            } catch {
                print("Error adding exercises: \(error)")
            }
        }
    }
}

struct SelectExerciseRow: View {
    let exercise: Exercise
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? .cyan : .gray)
                Text(exercise.exerciseName)
                Spacer()
                Image(systemName: "info.circle")
                    .foregroundColor(.cyan)
            }
        }
        .foregroundColor(.primary)
    }
}

// MARK: - Preview Provider
struct ExerciseSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        ExerciseSelectionView(
            viewModel: WorkoutsViewModel(),
            workout: Workout(id: 1, user_id: UUID(), workoutName: "Sample Workout", programId: 1),
            onExercisesAdded: { _ in }
        )
    }
}

//import SwiftUI
//
//struct ExerciseSelectionView: View {
//    @ObservedObject var viewModel: WorkoutsViewModel
//    @State private var selectedExercises: Set<Exercise> = []
//    @State private var exercises: [Exercise] = []
//    @Environment(\.presentationMode) var presentationMode
//    let workout: Workout?
//    let onExercisesAdded: ([Exercise]) -> Void
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                List {
//                    ForEach(exercises) { exercise in
//                        SelectExerciseRow(exercise: exercise, isSelected: selectedExercises.contains(exercise)) {
//                            toggleExerciseSelection(exercise)
//                        }
//                    }
//                }
//                
//                Button(action: {
//                    addExercises(Array(selectedExercises))
//                }) {
//                    Text("Add(\(selectedExercises.count))")
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.blue)
//                        .cornerRadius(8)
//                }
//                .padding()
//            }
//            .navigationTitle("Add Exercise")
//            .navigationBarTitleDisplayMode(.inline)
//            .navigationBarItems(
//                leading: Button("Cancel") {
//                    presentationMode.wrappedValue.dismiss()
//                },
//                trailing: Button("Add(\(selectedExercises.count))") {
//                    addExercises(Array(selectedExercises))
//                }
//                .foregroundColor(.blue)
//            )
//        }
//        .task {
//            await fetchExercises()
//        }
//    }
//    
//    private func fetchExercises() async {
//        do {
//            exercises = try await viewModel.fetchAllExercises()
//        } catch {
//            print("Error fetching exercises: \(error)")
//        }
//    }
//    
//    private func toggleExerciseSelection(_ exercise: Exercise) {
//        if selectedExercises.contains(exercise) {
//            selectedExercises.remove(exercise)
//        } else {
//            selectedExercises.insert(exercise)
//        }
//    }
//    
//    private func addExercises(_ exercises: [Exercise]) {
//        Task {
//            do {
//                if let workout = workout {
//                    try await viewModel.addExercisesToWorkout(exercises, workout: workout)
//                }
//                onExercisesAdded(exercises)
//                await MainActor.run {
//                    presentationMode.wrappedValue.dismiss()
//                }
//            } catch {
//                print("Error adding exercises: \(error)")
//            }
//        }
//    }
//}
//
//struct SelectExerciseRow: View {
//    let exercise: Exercise
//    let isSelected: Bool
//    let action: () -> Void
//    
//    var body: some View {
//        Button(action: action) {
//            HStack {
//                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
//                    .foregroundColor(isSelected ? .cyan : .gray)
//                Text(exercise.exerciseName)
//                Spacer()
//                Image(systemName: "info.circle")
//                    .foregroundColor(.cyan)
//            }
//        }
//        .foregroundColor(.primary)
//    }
//}
//
//struct ExerciseSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExerciseSelectionView(
//            viewModel: WorkoutsViewModel(),
//            workout: Workout(id: 1, user_id: UUID(), workoutName: "Sample Workout", programId: 1),
//            onExercisesAdded: {_ in }
//        )
//    }
//}
