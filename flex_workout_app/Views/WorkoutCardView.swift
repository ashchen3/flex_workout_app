//
//  WorkoutCardView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct WorkoutCardView: View {
    let workout: WorkoutTemplate
    let isTopCard: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(workout.title)
                    .font(.headline)
                Spacer()
                Text(formattedDate(Date().timeIntervalSince1970)) //placeholder for now
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Divider()
            
            ForEach(workout.exerciseTypes, id: \.title) { exercise in
                HStack {
                    Text(exercise.title)
                    Spacer()
                    Text("\(exercise.defaultSets)×\(exercise.defaultReps) \(Int(exercise.defaultWeight))lb")
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .overlay(
                    isTopCard ?  // Apply the left border only if it's the top card
                    Rectangle()
                        .fill(Color.cyan)
                        .frame(width: 5)  // Left border width
                        .padding(.leading, -10)  // Ensure it's flush with the left edge
                    : nil, alignment: .leading  // Align the overlay to the left
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
    static var workout = WorkoutTemplate.sampleWorkoutTemplates[0]
    static var previews: some View {
        WorkoutCardView(workout: workout, isTopCard: true)
            //.previewLayout(.fixed(width: 400, height: 200))
            .previewLayout(.sizeThatFits)
            .padding()

    }
}

