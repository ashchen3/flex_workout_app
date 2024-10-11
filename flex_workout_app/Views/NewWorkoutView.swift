//
//  NewWorkout.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/10/24.
//

import SwiftUI

struct NewWorkoutView: View {
    let programId: Int

    @State private var workoutName = ""
    @State private var exercises: [Exercise] = [] //to fill with prospective exercises
    @StateObject private var viewModel: WorkoutsViewModel

    @Environment(\.presentationMode) var presentationMode
    
    init(viewModel: WorkoutsViewModel, programId: Int) {
            self.programId = programId
            self._viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("Workout Name", text: $workoutName)
                }

                Section {
//                    ForEach(exercises) { exercise in
//                        NavigationLink(destination: Text("Edit \(exercise.exerciseName)")) {
//                            Text(exercise.exerciseName)
//                        }
//                    }
                    Button(action: {}) {
                        Text("Add Exercise")
                            .foregroundColor(.blue)
                    }
                }

            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Create Workout")
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
                                try await viewModel.createWorkout(workoutName: workoutName, programId: programId)
                                try await viewModel.fetchWorkouts(for: programId)
                                await MainActor.run {
                                    presentationMode.wrappedValue.dismiss()
                                }
                            } catch {
                                print("Error saving workout: \(error)")
                            }
                        }
                    }
                }
            }
        }
    }
}

//struct NewWorkout_Previews: PreviewProvider {
//    static var previews: some View {
//        NewWorkoutView(viewModel: WorkoutsViewModel(), programId: 20)
//    }
//}


