//
//  InWorkoutView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct InWorkoutView: View {
    //@StateObject var viewModel: InWorkoutViewModel
    
    @StateObject private var timerManager = TimerManager()
    @State private var showTimer = false

    
    let workoutWE: WorkoutWithExercises
    
    var body: some View {
        VStack {
            // TODO: Make the workout changeable based on the top selection
            Text(workoutWE.workout.workoutName)
                .bold()
                .font(.title2)

            List {
                ForEach(workoutWE.exercises) {
                    exercise in SingleExerciseRowView(exercise: exercise) {
                        updatedExercise in
                            
                            //TODO: Handle Update to exercise
                            //TODO: make another callback in SingleExerciseRowView that starts the timer
                    }
                }
            }
            .listStyle(PlainListStyle())
            
            Button("Start Timer") {
                if showTimer {
                    timerManager.resetTimer()
                } else {
                    showTimer = true
                }
            }
            .padding()
            if showTimer {
                TimerView(timerManager: timerManager, totalTime: 180) {
                    showTimer = false
                    }
                    .transition(.move(edge: .bottom))
                    .animation(.spring(), value: showTimer)
                    .padding(.bottom)
            }
        }
        
            
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

