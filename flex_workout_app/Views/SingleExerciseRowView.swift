//
//  SingleExerciseRowView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/12/24.
//

import SwiftUI

struct SingleExerciseRowView: View {
    let exercise: Exercise
    let onExerciseUpdate: (Exercise) -> Void  // Add this line
    @State private var completedSets: [Int] = []
    @State private var showingEditSheet = false


    init(exercise: Exercise, onExerciseUpdate: @escaping (Exercise) -> Void) {
        self.exercise = exercise
        self.onExerciseUpdate = onExerciseUpdate
        self._completedSets = State(initialValue: Array(repeating: 0, count: exercise.defaultSets))
    }
    
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(exercise.exerciseName)
                    .font(.headline)
                Spacer()
                Text("\(exercise.defaultSets)×\(exercise.defaultReps) \(String(format: "%.0f", exercise.currentWeight ?? exercise.defaultWeight))lb")
                    .font(.subheadline)
                
                //TODO: Make Exercise actually Editable. The sheet doesn't update backend right now.
                Button(action: {
                    showingEditSheet = true
                }) {
                    Image(systemName: "chevron.right")
                        .foregroundColor(.cyan)
                }
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(0..<exercise.defaultSets, id: \.self) { index in
                        Button(action: {
                            let index = index
                            if completedSets[index] == 0 {
                                completedSets[index] = exercise.defaultReps
                            } else if completedSets[index] > 0 {
                                completedSets[index] -= 1
                            }
                        }) {
                            ZStack {
                                Circle()
                                    .fill(completedSets[index] > 0 ? Color.cyan : Color.gray)
                                    .frame(width: 60, height: 50)
                                Text("\(completedSets[index] != 0 ? completedSets[index] : exercise.defaultReps)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 18, weight: .bold))
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, 8)
        .sheet(isPresented: $showingEditSheet) {
            EditExerciseView(exercise: exercise) { updatedExercise in
                onExerciseUpdate(updatedExercise)  // Parent callback

            }
        }
    }
}

struct SingleExerciseRowView_Previews: PreviewProvider {
    static var previews: some View {
        SingleExerciseRowView(exercise: Exercise(
            id: 1,
            user_id: UUID(),
            exerciseName: "Squat",
            defaultWeight: 45,
            defaultReps: 5,
            defaultSets: 5,
            currentWeight: 190
        )) {_ in }
        .previewLayout(.sizeThatFits)
        .padding()
        //.background(Color.black)
        //.environment(\.colorScheme, .dark)
    }
}
