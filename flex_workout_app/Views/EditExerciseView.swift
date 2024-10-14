//
//  EditExerciseView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/20/24.
//

import SwiftUI

struct EditExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var updatedExercise: Exercise
    let onSave: (Exercise) -> Void
    
    
    @Environment(\.presentationMode) var presentationMode
    
    init(exercise: Exercise, onSave: @escaping (Exercise) -> Void) {
        _updatedExercise = State(initialValue: exercise)
        self.onSave = onSave
    }
    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Exercise Name")) {
                    TextField("Enter exercise name", text: $updatedExercise.exerciseName)
                }

                Section(header: Text("Sets")) {
                    TextField("Enter sets", value: $updatedExercise.defaultSets, format: .number)
                }

                Section(header: Text("Reps")) {
                    TextField("Enter reps", value: $updatedExercise.defaultReps, format: .number)
                }

                Section(header: Text("Exercise Weight")) {
                    TextField("Enter weight", value: $updatedExercise.currentWeight, format: .number)
                }

                Section(header: Text("Increment")) {
                    TextField("Enter increment", value: $updatedExercise.increment, format: .number)
                }

                Section(header: Text("Frequency")) {
                    TextField("Enter frequency", value: $updatedExercise.incrementFreq, format: .number)
                }

                Section(header: Text("Deload")) {
                    TextField("Enter deload", value: $updatedExercise.deload, format: .number)
                }

                Section(header: Text("Deload Frequency")) {
                    TextField("Enter frequency", value: $updatedExercise.deloadFreq, format: .number)

                }
            }
            
            .navigationTitle("Edit \(updatedExercise.exerciseName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        Task {
                            do {
                                onSave(updatedExercise)
                                try await viewModel.updateExercise(updatedExercise)
                                await MainActor.run {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } catch {
                                print("Error updating exercise: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}

