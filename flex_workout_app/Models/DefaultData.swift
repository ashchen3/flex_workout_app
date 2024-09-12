import FirebaseFirestore

class DataSeeder {
    private let db = Firestore.firestore()
    
    func seedDefaultData() {
        // Add Exercise Types
        for exercise in ExerciseType.sampleExercises {
            let exerciseData: [String: Any] = [
                "id": exercise.id.uuidString,
                "title": exercise.title,
                "defaultSets": exercise.defaultSets,
                "defaultReps": exercise.defaultReps,
                "defaultWeight": exercise.defaultWeight,
                "increment": exercise.increment,
                "incrementFreq": exercise.incrementFreq,
                "deload": exercise.deload,
                "deloadFreq": exercise.deloadFreq
            ]
            db.collection("Users").document("userID") // Replace with actual user ID
                .collection("ExerciseType")
                .document(exercise.id.uuidString)
                .setData(exerciseData) { error in
                    if let error = error {
                        print("Error adding ExerciseType: \(error)")
                    } else {
                        print("ExerciseType added successfully")
                    }
                }
        }

        // Add Workout Templates
        for workoutTemplate in WorkoutTemplate.sampleWorkoutTemplates {
            let workoutTemplateData: [String: Any] = [
                "id": workoutTemplate.id.uuidString,
                "title": workoutTemplate.title,
                "exerciseTypes": workoutTemplate.exerciseTypes.map { $0.id.uuidString } // Store references or IDs
            ]
            db.collection("Users").document("userID") // Replace with actual user ID
                .collection("WorkoutTemplate")
                .document(workoutTemplate.id.uuidString)
                .setData(workoutTemplateData) { error in
                    if let error = error {
                        print("Error adding WorkoutTemplate: \(error)")
                    } else {
                        print("WorkoutTemplate added successfully")
                    }
                }
        }

        // Add Program Templates
        for programTemplate in ProgramTemplate.sampleProgramTemplates {
            let programTemplateData: [String: Any] = [
                "id": programTemplate.id.uuidString,
                "title": programTemplate.title,
                "workoutTemplates": programTemplate.workoutTemplates.map { $0.id.uuidString } // Store references or IDs
            ]
            db.collection("Users").document("userID") // Replace with actual user ID
                .collection("ProgramTemplate")
                .document(programTemplate.id.uuidString)
                .setData(programTemplateData) { error in
                    if let error = error {
                        print("Error adding ProgramTemplate: \(error)")
                    } else {
                        print("ProgramTemplate added successfully")
                    }
                }
        }
    }
}

