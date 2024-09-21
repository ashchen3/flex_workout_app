//
//  DataTypes.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/12/24.
//

import Foundation




// Users -> ExerciseType -> Squat
struct ExerciseType: Codable, Identifiable {
    var id: String          // assigned ID
    var title: String       // name of exercise
    var defaultSets: Int
    var defaultReps: Int
    var defaultWeight: Float
    var increment: Float
    var iFreq: Int
    var deload: Float
    var dFreq: Int
    
    init(id: String = UUID().uuidString, title: String, defaultSets: Int = 5, defaultReps: Int = 5, defaultWeight: Float = 45, increment: Float = 5, iFreq: Int = 1, deload: Float = 0.10, dFreq: Int = 3) {
        self.id = id  //If not filled, will create a UUID string. If filled, the id will be that created (by Firebase)
        self.title = title
        self.defaultSets = defaultSets
        self.defaultReps = defaultReps
        self.defaultWeight = defaultWeight
        self.increment = increment
        self.iFreq = iFreq
        self.deload = deload
        self.dFreq = dFreq
        
    }
}

// Users -> (userID) -> WorkoutTemplate -> (workoutTemplateId)
struct WorkoutTemplate: Codable, Identifiable {
    var id: String
    var title: String
    var exerciseTypes: [ExerciseType]
    
    init(id: String = UUID().uuidString, title: String, exerciseTypes: [ExerciseType]) {
        self.id = id
        self.title = title
        self.exerciseTypes = exerciseTypes
    }
    
}


// Users -> ProgramTemplate -> Push-Pull-Legs
struct ProgramTemplate: Codable, Identifiable {
    var id: String
    var title: String
    var workoutTemplates: [WorkoutTemplate]
    
    init(id: String = UUID().uuidString, title: String, workoutTemplates: [WorkoutTemplate]) {
        self.id = id
        self.title = title
        self.workoutTemplates = workoutTemplates
    }
}


extension ExerciseType {
    static let sampleExercises: [ExerciseType] =
    [
        ExerciseType(title: "Squat",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
        ExerciseType(title: "Bench Press",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
        ExerciseType(title: "Barbell Row",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
        ExerciseType(title: "Overhead Press",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
        ExerciseType(title: "Deadlift",
                     defaultSets: 1,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 10,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
        ExerciseType(title: "Weighted Pull-ups",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 0,
                     increment: 2.5,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
        ExerciseType(title: "Weighted Dips",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 0,
                     increment: 2.5,
                     iFreq: 1,
                     deload: 0.1,
                     dFreq: 3),
    ]
}

extension WorkoutTemplate {
    static let sampleWorkoutTemplates: [WorkoutTemplate] =
    [
        WorkoutTemplate(title: "Workout A", exerciseTypes: [
            ExerciseType.sampleExercises[0],
            ExerciseType.sampleExercises[1],
            ExerciseType.sampleExercises[2],
        ]),
        WorkoutTemplate(title: "Workout B", exerciseTypes: [
            ExerciseType.sampleExercises[0],
            ExerciseType.sampleExercises[3],
            ExerciseType.sampleExercises[4],
        ]),
        WorkoutTemplate(title: "Push Day", exerciseTypes: [
            ExerciseType.sampleExercises[6],
        ]),
        WorkoutTemplate(title: "Pull Day", exerciseTypes: [
            ExerciseType.sampleExercises[5],
        ]),
        WorkoutTemplate(title: "Leg Day", exerciseTypes: [
            ExerciseType.sampleExercises[0],
        ]),
    ]
}

extension ProgramTemplate {
    static let sampleProgramTemplates: [ProgramTemplate] =
    [
        ProgramTemplate(title: "Stronglifts 5x5", workoutTemplates: [
            WorkoutTemplate.sampleWorkoutTemplates[0],
            WorkoutTemplate.sampleWorkoutTemplates[1],
        ]),
        ProgramTemplate(title: "Push-Pull-Legs", workoutTemplates: [
            WorkoutTemplate.sampleWorkoutTemplates[2],
            WorkoutTemplate.sampleWorkoutTemplates[3],
            WorkoutTemplate.sampleWorkoutTemplates[4],
        ]),
    ]
}



