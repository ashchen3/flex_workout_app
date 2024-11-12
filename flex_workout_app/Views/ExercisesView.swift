//
//  ExercisesView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct ExercisesView: View {
    @StateObject var viewModel = WorkoutsViewModel()
    @State private var selectedProgram: Int?
    @EnvironmentObject var userState: UserState
    @State private var workoutsWE: [(Workout, [Exercise])] = []
    @State private var selectedExercise: Exercise?
    @State private var showEditView = false
    
    var body: some View {
        NavigationStack {
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
        
    }
    
    private func fetchDataAndWorkouts() async {
        do {
            try await userState.fetchProfile()
            selectedProgram = userState.profile?.selectedProgram
            if let programId = selectedProgram {
                _ = try await viewModel.fetchWorkouts(for: programId)
                await fetchExercisesForWorkouts()
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    private func fetchExercisesForWorkouts() async {
        workoutsWE = []
        for workout in viewModel.workouts {
            do {
                let exercises = try await viewModel.fetchProgramExercises(for: workout)
                workoutsWE.append((workout, exercises))
            } catch {
                print("Error fetching exercises for workout \(workout.workoutName): \(error)")
            }
        }
    }
    
    private func weightsView(programId: Int) -> some View {
        List {
            ForEach(workoutsWE, id: \.0.id) { workout, exercises in
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
        .listStyle(PlainListStyle()) 
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    showEditView = true
                }) {
                    Text("Edit")
                        .foregroundColor(.cyan)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
        .sheet(item: $selectedExercise) { exercise in
            EditExerciseView(exercise: exercise) { updatedExercise in
                if let workoutIndex = workoutsWE.firstIndex(where: { $0.1.contains(where: { $0.id == updatedExercise.id }) }),
                   let exerciseIndex = workoutsWE[workoutIndex].1.firstIndex(where: { $0.id == updatedExercise.id }) {
                        // Update in place, preserving order
                        workoutsWE[workoutIndex].1[exerciseIndex] = updatedExercise
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
