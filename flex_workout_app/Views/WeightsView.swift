//
//  WeightsView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct WeightsView: View {
    let workouts: [(String, [Exercise])] = [
        ("Workout A", [
            Exercise(id: 1, exerciseName: "Squat", description: nil, defaultReps: 5, defaultSets: 5, defaultWeight: 130),
            Exercise(id: 2, exerciseName: "Bench Press", description: nil, defaultReps: 5, defaultSets: 5, defaultWeight: 75),
            Exercise(id: 3, exerciseName: "Barbell Row", description: nil, defaultReps: 5, defaultSets: 5, defaultWeight: 65)
        ]),
        ("Workout B", [
            Exercise(id: 4, exerciseName: "Squat", description: nil, defaultReps: 5, defaultSets: 5, defaultWeight: 135),
            Exercise(id: 5, exerciseName: "Overhead Press", description: nil, defaultReps: 5, defaultSets: 5, defaultWeight: 45),
            Exercise(id: 6, exerciseName: "Deadlift", description: nil, defaultReps: 5, defaultSets: 1, defaultWeight: 145)
        ])
    ]
    
    var body: some View {
        WorkoutView(workouts: workouts) { exercise in
            ExerciseRow(exercise: exercise) { exercise in
                Text("\(Int(exercise.defaultWeight))lb")
                    .foregroundColor(.primary)
            }
        }
    }
}

struct WeightsView_Previews: PreviewProvider {
    static var previews: some View {
        WeightsView()
    }
}
