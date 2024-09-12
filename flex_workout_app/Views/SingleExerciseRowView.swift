//
//  SingleExerciseRowView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/12/24.
//

import SwiftUI

struct SingleExerciseRowView: View {
    let exercise: Exercise
    @State private var completedSets: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(exercise.title)
                    .font(.headline)
                Spacer()
                Text("\(exercise.sets)×\(exercise.reps) \(String(format: "%.0f", exercise.weight))lb")
                    .font(.subheadline)
                Image(systemName: "chevron.right")
                    .foregroundColor(.cyan)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<exercise.sets, id: \.self) { index in
                        Button(action: {
                            if completedSets == index {
                                completedSets += 1
                            } else if completedSets == index + 1 {
                                completedSets -= 1
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(index < completedSets ? Color.cyan : Color.gray)
                                    .frame(width: 60, height: 50)
                                Text("\(exercise.reps)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .padding(.vertical, 8)
    }
}

struct SingleExerciseRowView_Previews: PreviewProvider {
    static var previews: some View {
        SingleExerciseRowView(exercise: Exercise(
            title: "Squat",
            sets: 5,
            reps: 5,
            weight: 190
        ))
        .previewLayout(.sizeThatFits)
        .padding()
        //.background(Color.black)
        //.environment(\.colorScheme, .dark)
    }
}
