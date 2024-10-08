//
//  SetsRepsView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct SetsRepsView: View {
    
    @EnvironmentObject var userState: UserState

    
    let workouts: [(String, [Exercise])] = [
        ("Workout A", [
            Exercise(id: 1, exerciseName: "Squat", defaultWeight: 130, defaultReps: 5, defaultSets: 5),
            Exercise(id: 2, exerciseName: "Bench Press", defaultWeight: 75, defaultReps: 5, defaultSets: 5),
            Exercise(id: 3, exerciseName: "Barbell Row", defaultWeight: 65, defaultReps: 5, defaultSets: 5)
        ]),
        ("Workout B", [
            Exercise(id: 4, exerciseName: "Squat", defaultWeight: 135, defaultReps: 5, defaultSets: 5),
            Exercise(id: 5, exerciseName: "Overhead Press", defaultWeight: 45, defaultReps: 5, defaultSets: 5),
            Exercise(id: 6, exerciseName: "Deadlift", defaultWeight: 145, defaultReps: 5, defaultSets: 1)
        ])
    ]
    
    var body: some View {
        VStack {
            if let activeProgNum = userState.profile?.selectedProgram {
                Text("\(activeProgNum)")
            }
            WorkoutView(workouts: workouts) { exercise in
                ExerciseRow(exercise: exercise) { exercise in
                    Text("\(exercise.defaultSets)×\(exercise.defaultReps)")
                        .foregroundColor(.primary)
                }
            }
        }
        .task {
            try? await userState.fetchProfile()
        }
        
    }
}


struct SetsRepsView_Previews: PreviewProvider {
    static var previews: some View {
        SetsRepsView()
            .environmentObject(UserState())
    }
}
