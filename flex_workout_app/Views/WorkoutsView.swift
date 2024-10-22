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
                _ = try await viewModel.fetchWorkouts(for: programId)
                try? await viewModel.fetchWorkoutsWithExercises(for: programId)
            }
        } catch {
            print("Error: \(error)")
        }
    }
        
    private func workoutView(programId: Int) -> some View {
        NavigationView {
            List {
                ForEach(viewModel.workoutsWithExercises) { workoutWithExercises in
                    WorkoutRow(viewModel: viewModel, workoutWithExercises: workoutWithExercises)
                        .onTapGesture {
                            selectedWorkout = workoutWithExercises.workout
                        }
                }
                .onMove(perform: move)
            }
            .listStyle(PlainListStyle()) 
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
                    EditButton()
                        .foregroundColor(.cyan)
                }
            }
            .sheet(item: $selectedWorkout) { workout in
                EditWorkoutView(workout: workout, viewModel: viewModel, programId: programId)
            }
            .sheet(isPresented: $isCreatingNewWorkout) {
                NewWorkoutView(viewModel: viewModel, programId: programId)
            }
            .refreshable {
                await fetchDataAndWorkouts()
            }
        }
        .onChange(of: viewModel.workouts) {
            Task {
                await fetchDataAndWorkouts()
            }
        }
    }
    
    func move(from source: IndexSet, to destination: Int) {
        viewModel.workouts.move(fromOffsets: source, toOffset: destination)
        Task {
            try await viewModel.updateWorkoutOrder(workouts: viewModel.workouts)
        }
    }
}


struct WorkoutRow: View {
    @ObservedObject var viewModel: WorkoutsViewModel
    let workoutWithExercises: WorkoutWithExercises
        
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(workoutWithExercises.workout.workoutName)
                    .font(.headline)
                
                Text(
                    workoutWithExercises.exercises.prefix(2)
                        .map { $0.exerciseName }
                        .joined(separator: ", ") +
                    (workoutWithExercises.exercises.count > 2 ? ", ..." : "")
                )
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

//struct ScheduleButton: View {
//    var body: some View {
//        Button(action: {}) {
//            HStack {
//                Text("Schedule")
//                    .foregroundColor(.cyan)
//                Spacer()
//                Text("3×/week")
//                    .foregroundColor(.black)
//                Image(systemName: "chevron.right")
//                    .foregroundColor(.gray)
//            }
//            .padding()
//            .background(Color.white)
//            .cornerRadius(10)
//            .overlay(
//                RoundedRectangle(cornerRadius: 10)
//                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//            )
//        }
//    }
//}

struct WorkoutProgramView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
            .environmentObject(UserState())
    }
}
