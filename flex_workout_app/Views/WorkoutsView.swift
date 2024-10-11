//
//  WorkoutsView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct WorkoutsView: View {
    @StateObject var viewModel = WorkoutsViewModel()
    @State private var isCreatingNewWorkout = false
    @State private var showEditView = false
    @State private var selectedWorkout: Workout?
    @State private var selectedProgram: Int?
    @EnvironmentObject var userState: UserState
    
    init() {
            _selectedProgram = State(initialValue: nil)
    }
    
    var body: some View {
        Group {
            if let programId = selectedProgram {
                workoutView(programId: programId)
            } else {
                noProgramView()
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
            }
        } catch {
            print("Error: \(error)")
        }
    }
        
    private func workoutView(programId: Int) -> some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 0) {
                        ForEach(viewModel.workouts) { workout in
                            WorkoutRow(viewModel: viewModel, workout: workout)
                                .onTapGesture {
                                    selectedWorkout = workout
                                }
                            Divider().background(Color.gray.opacity(0.3))
                        }
                    }
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )

                    ScheduleButton()
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            isCreatingNewWorkout = true
                        }) {
                            Text("Add Workout")
                                .foregroundColor(.cyan)
                        }
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: {
                            showEditView = true
                        }) {
                            Text("Edit")
                                .foregroundColor(.cyan)
                        }
                    }
                }
                .sheet(item: $selectedWorkout) { workout in
                    EditWorkoutView(workout: workout, viewModel: viewModel, programId: programId)
                }
                .sheet(isPresented: $isCreatingNewWorkout) {
                    NewWorkoutView(viewModel: viewModel, programId: programId)
                }
                .padding()
            }
        }
        .onChange(of: viewModel.workouts) {
            Task {
                await fetchDataAndWorkouts()
            }
        }
    }
    
    
    private func noProgramView() -> some View {
        VStack {
            Text("Please select a program")
                .foregroundColor(.gray)
                .italic()
        }
    }
}


struct WorkoutRow: View {
    @ObservedObject var viewModel: WorkoutsViewModel
    let workout: Workout
    @State var exercises: [Exercise] = []
    
        
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(workout.workoutName)
                    .font(.headline)
                
                //TODO: WE WANT THIS TO BE for each exercise
                
//                Text("Exercise 1, Exercise 2, Exercise 3, ...")
//                  .font(.subheadline)
//                  .foregroundColor(.gray)
                
                Text(
                    exercises.prefix(2)
                        .map { $0.exerciseName }
                        .joined(separator: ", ") +
                    (exercises.count > 2 ? ", ..." : "")
                )
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .onAppear {
            Task {
                exercises = try await viewModel.fetchProgramExercises(for: workout)
            }
        }
        .padding()
    }
}

struct ScheduleButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Text("Schedule")
                    .foregroundColor(.cyan)
                Spacer()
                Text("3×/week")
                    .foregroundColor(.black)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct WorkoutProgramView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
            .environmentObject(UserState())
    }
}
