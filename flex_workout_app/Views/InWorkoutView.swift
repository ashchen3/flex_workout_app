//
//  InWorkoutView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//




import SwiftUI

struct InWorkoutView: View {
    @StateObject var viewModel = InWorkoutViewModel()

    @StateObject private var timerManager = TimerManager()
    @State private var showTimer = false
    
    @State var workoutWE: WorkoutWithExercises
    
    @State private var showLog = false
    @State private var logWO = false
    @State private var exerciseCompletedSets: [Int: [Int?]] = [:]
    
    @Environment(\.dismiss) private var dismiss

    
    var body: some View {
        VStack {
    
            HStack {
                Spacer() // This will help push the text to the center
                
                Button("Log Workout") {
                    if showLog {
                        logWO = true
                    }
                }
                .font(.body)
                .foregroundColor(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(showLog ? Color.cyan : Color.gray)
                .cornerRadius(8)
            }
            .padding(.horizontal)
            
            
            List {
                ForEach(workoutWE.exercises) { exercise in
                    SingleExerciseRowView(
                        exercise: exercise,
                        onExerciseUpdate: { updatedExercise in
                            //TODO: Handle Update to exercise
                        },
                        onTimerStart: {
                            startTimer()
                            showLog = true
                        },
                        onSetsCompleted: { exercise, sets in
                            exerciseCompletedSets[exercise.id!] = sets
                        }
                    )
                }
            }
            .listStyle(PlainListStyle())
            
            if showTimer {
                TimerView(timerManager: timerManager, totalTime: 180) {
                    timerManager.stopTimer()
                    showTimer = false
                }
                .animation(.spring(), value: showTimer)
                .padding(.bottom)
            }
        }
        .alert(isPresented: $logWO) {
            Alert(
                title: Text("Log Workout?"),
                message: Text(generateWorkoutLog()),
                primaryButton: .default(Text("Log")) { logWorkout()},
                secondaryButton: .cancel() {
                    logWO = false
                }
            )
        }
        
    }
    func startTimer() -> Void {
        if showTimer {
            timerManager.resetTimer()
        } else {
            showTimer = true
        }
    }
    
    func generateWorkoutLog() -> String {
        var log = ""
        for exercise in workoutWE.exercises {
            let sets = exerciseCompletedSets[exercise.id!] ?? Array(repeating: nil, count: exercise.defaultSets)
            log += "\(exercise.exerciseName) (\(String(format: "%.1f", exercise.currentWeight ?? exercise.defaultWeight))lb):\n"
            log += "\(formatSets(sets))\n\n"
        }
        return log
    }
    
    func formatSets(_ sets: [Int?]) -> String {
        return "[\(sets.map { $0 == nil ? "None" : "\($0!)" }.joined(separator: ", "))]"
    }
    func logWorkout() {
        Task {
            do {
                try await viewModel.logCompletedSets(exerciseCompletedSets: exerciseCompletedSets)
                print(generateWorkoutLog())
                dismiss()
            } catch {
                print("Error logging workout: \(error)")
            }
        }
        
        print(generateWorkoutLog())
    }
    
}


struct InWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        InWorkoutView(workoutWE: WorkoutWithExercises(
            workout: Workout(
                id: 1,
                user_id: UUID(),
                workoutName: "Leg Day",
                programId: 101,
                workoutOrder: 1
            ),
            exercises: [
                Exercise(
                    id: 1,
                    user_id: UUID(),
                    exerciseName: "Squat",
                    defaultWeight: 100.0,
                    defaultReps: 5,
                    defaultSets: 3,
                    increment: 2.5,
                    incrementFreq: 1,
                    deload: nil,
                    deloadFreq: nil,
                    currentWeight: 102.5
                ),
                Exercise(
                    id: 2,
                    user_id: UUID(),
                    exerciseName: "Deadlift",
                    defaultWeight: 120.0,
                    defaultReps: 5,
                    defaultSets: 1,
                    increment: 5.0,
                    incrementFreq: 1,
                    deload: nil,
                    deloadFreq: nil,
                    currentWeight: 125.0
                ),
                Exercise(
                    id: 3,
                    user_id: UUID(),
                    exerciseName: "Lunges",
                    defaultWeight: 40.0,
                    defaultReps: 10,
                    defaultSets: 3,
                    increment: 2.0,
                    incrementFreq: 2,
                    deload: nil,
                    deloadFreq: nil,
                    currentWeight: 42.0
                )
            ]
        ))
    }
}

