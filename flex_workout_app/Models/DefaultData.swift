import FirebaseFirestore


public func addDefaultTemplates(userId: String) {
    let db = Firestore.firestore()
    
    // Add default exercises
    let exerciseTypesRef = db.collection("users").document(userId).collection("ExerciseType")
    for exercise in ExerciseType.sampleExercises {
        exerciseTypesRef.document(exercise.id).setData(exercise.asDictionary())
    }
    
    // Add default workout templates
    let workoutTemplatesRef = db.collection("users").document(userId).collection("WorkoutTemplate")
    for workoutTemplate in WorkoutTemplate.sampleWorkoutTemplates {
        workoutTemplatesRef.document(workoutTemplate.id).setData(workoutTemplate.asDictionary())
    }
    
    // Add default program templates
    let programTemplatesRef = db.collection("users").document(userId).collection("ProgramTemplate")
    for programTemplate in ProgramTemplate.sampleProgramTemplates {
        programTemplatesRef.document(programTemplate.id).setData(programTemplate.asDictionary())
    }
}



