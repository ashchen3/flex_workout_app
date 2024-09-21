//
//  InWorkoutView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct InWorkoutView: View {
    //@StateObject var viewModel: InWorkoutViewModel
    
    let workout: WorkoutTemplate
    
    var body: some View {
        VStack {
            Text(workout.title)
                .bold()
                .font(.title2)
            // Add more details about the workout here
            List(workout.exerciseTypes) { exercise in SingleExerciseRowView(exercise: exercise)
            }
            .listStyle(PlainListStyle())
        }
        
            
    }
}

#Preview {
    InWorkoutView(workout: WorkoutTemplate.sampleWorkoutTemplates[0])
}
