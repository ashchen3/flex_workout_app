//
//  WorkoutCardView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct WorkoutCardView: View {
    let workoutWithExercises: WorkoutWithExercises
    let isTopCard: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(workoutWithExercises.workout.workoutName)
                    .font(.headline)
                Spacer()
                Text(formattedDate(Date().timeIntervalSince1970)) // placeholder for now
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            ForEach(workoutWithExercises.exercises) { exercise in
                HStack {
                    Text(exercise.exerciseName)
                    Spacer()
                    Text("\(exercise.defaultSets)×\(exercise.defaultReps) \(Int(exercise.currentWeight ?? Float(exercise.defaultWeight)))lb")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 1)
        .overlay(
            isTopCard ?
                Rectangle()
                    .fill(Color.cyan)
                    .frame(width: 5)
                    .padding(.leading, -10)
                : nil,
            alignment: .leading
        )
    }
    
    private func formattedDate(_ timeInterval: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timeInterval)
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

struct WorkoutCardView_Previews: PreviewProvider {
    static var sampleWorkout = Workout(id: 1, user_id: UUID(), workoutName: "Sample Workout", programId: 1, workoutOrder: 1)
    static var sampleExercises = [
        Exercise(id: 1, user_id: UUID(), exerciseName: "Squat", defaultWeight: 100, defaultReps: 5, defaultSets: 3),
        Exercise(id: 2, user_id: UUID(), exerciseName: "Bench Press", defaultWeight: 80, defaultReps: 5, defaultSets: 3)
    ]
    static var workoutWithExercises = WorkoutWithExercises(workout: sampleWorkout, exercises: sampleExercises)
    
    static var previews: some View {
        WorkoutCardView(workoutWithExercises: workoutWithExercises, isTopCard: true)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}

