//
//  EditExerciseView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/20/24.
//

import SwiftUI

struct EditExerciseView: View {
    let exercise: ExerciseType
    
    var body: some View {
        Text("Edit \(exercise.title)")
    }
}

#Preview {
    EditExerciseView(exercise: ExerciseType(
        title: "Squat",
        defaultSets: 5,
        defaultReps: 5,
        defaultWeight: 190
    ))
}
