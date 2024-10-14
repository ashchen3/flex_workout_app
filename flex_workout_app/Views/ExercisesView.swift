//
//  ExercisesView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

import SwiftUI

struct ExercisesView: View {
    @StateObject var viewModel = WorkoutsViewModel()
    @State private var selectedProgram: Int?
    @EnvironmentObject var userState: UserState
    @State private var workoutsWithExercises: [(Workout, [Exercise])] = []
    @State private var selectedExercise: Exercise?
    @State private var showEditView = false
    
    var body: some View {
        Group {
            if let programId = selectedProgram {
                weightsView(programId: programId)
            } else {
                NoProgramView()
            }
        }
        .task {
            await fetchDataAndWorkouts()
        }
    }
    
    private func fetchDataAndWorkouts() async {
        do {
            try await userState.fetchProfile()
            selectedProgram = userState.profile?.selectedProgram
            if let programId = selectedProgram {
                try await viewModel.fetchWorkouts(for: programId)
                await fetchExercisesForWorkouts()
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func fetchExercisesForWorkouts() async {
        workoutsWithExercises = []
        for workout in viewModel.workouts {
            do {
                let exercises = try await viewModel.fetchProgramExercises(for: workout)
                workoutsWithExercises.append((workout, exercises))
            } catch {
                print("Error fetching exercises for workout \(workout.workoutName): \(error)")
            }
        }
    }
    
    private func weightsView(programId: Int) -> some View {
        List {
            ForEach(workoutsWithExercises, id: \.0.id) { workout, exercises in
                Section(header: Text(workout.workoutName)) {
                    ForEach(exercises) { exercise in
                        ExerciseRow(exercise: exercise)
                            .onTapGesture {
                                selectedExercise = exercise
                            }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    //TODO: Make Edit View
                    showEditView = true
                }) {
                    Text("Edit")
                        .foregroundColor(.cyan)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .navigationTitle("Weights")
        .sheet(item: $selectedExercise) { exercise in
            EditExerciseView(exercise: exercise) { updatedExercise in
                if let index = workoutsWithExercises.firstIndex(where: { $0.1.contains(where: { $0.id == updatedExercise.id }) }) {
                    workoutsWithExercises[index].1.removeAll { $0.id == updatedExercise.id }
                    workoutsWithExercises[index].1.append(updatedExercise)
                }
                selectedExercise = nil
            }
            .environmentObject(viewModel)
        }
        .refreshable {
            await fetchDataAndWorkouts()
        }
    }
}

struct ExercisesView_Previews: PreviewProvider {
    static var previews: some View {
        ExercisesView()
            .environmentObject(UserState())
    }
}
