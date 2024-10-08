//
//  WorkoutTemplates.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/28/24.
//

import SwiftUI

struct WorkoutView<T: View>: View {
    let workouts: [(String, [Exercise])]
    let rowContent: (Exercise) -> T
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(workouts, id: \.0) { workout in
                        WorkoutSection(title: workout.0, exercises: workout.1, rowContent: rowContent)
                    }
                }
                .padding()
            }
            .background(Color.white)
        }
    }
}

struct WorkoutSection<T: View>: View {
    let title: String
    let exercises: [Exercise]
    let rowContent: (Exercise) -> T
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundColor(.gray)
            
            VStack(spacing: 0) {
                ForEach(exercises, id: \.id) { exercise in
                    NavigationLink(destination: BlankView(exercise: exercise)) {
                        rowContent(exercise)
                    }
                    if exercise.id != exercises.last?.id {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                    }
                }
            }
            .background(Color(UIColor.systemBackground))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct ExerciseRow<T: View>: View {
    let exercise: Exercise
    let rightContent: (Exercise) -> T
    
    var body: some View {
        HStack {
            Text(exercise.exerciseName)
                .foregroundColor(.primary)
            Spacer()
            rightContent(exercise)
        }
        .padding()
        .contentShape(Rectangle())
    }
}

struct BlankView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(exercise.exerciseName)
                .font(.title)
            Text("Default Weight: \(exercise.defaultWeight, specifier: "%.1f")lb")
            Text("Default Sets: \(exercise.defaultSets)")
            Text("Default Reps: \(exercise.defaultReps)")
        }
        .padding()
        .navigationTitle(exercise.exerciseName)
    }
}
