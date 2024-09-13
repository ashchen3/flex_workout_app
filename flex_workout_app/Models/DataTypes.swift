//
//  DataTypes.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/12/24.
//

import Foundation

// Users -> ExerciseType -> Squat
struct ExerciseType: Codable, Identifiable {
    var id: String
    var title: String
    var defaultSets: Int
    var defaultReps: Int
    var defaultWeight: Float
    var increment: Float
    var incrementFreq: Int
    var deload: Float
    var deloadFreq: Int
    
    init(id: String = UUID().uuidString, title: String, defaultSets: Int = 5, defaultReps: Int = 5, defaultWeight: Float = 45, increment: Float = 5, incrementFreq: Int = 1, deload: Float = 0.10, deloadFreq: Int = 3) {
        self.id = id  //If not filled, will create a UUID string. If filled, the id will be that created (by Firebase)
        self.title = title
        self.defaultSets = defaultSets
        self.defaultReps = defaultReps
        self.defaultWeight = defaultWeight
        self.increment = increment
        self.incrementFreq = incrementFreq
        self.deload = deload
        self.deloadFreq = deloadFreq
        
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
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
        ExerciseType(title: "Bench Press",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
        ExerciseType(title: "Barbell Row",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
        ExerciseType(title: "Overhead Press",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 5,
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
        ExerciseType(title: "Deadlift",
                     defaultSets: 1,
                     defaultReps: 5,
                     defaultWeight: 45,
                     increment: 10,
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
        ExerciseType(title: "Weighted Pull-ups",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 0,
                     increment: 2.5,
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
        ExerciseType(title: "Weighted Dips",
                     defaultSets: 5,
                     defaultReps: 5,
                     defaultWeight: 0,
                     increment: 2.5,
                     incrementFreq: 1,
                     deload: 0.1,
                     deloadFreq: 3),
    ]
}

// Users -> WorkoutTemplate -> Push Day
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
    ]
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

extension ProgramTemplate {
    static let sampleProgramTemplates: [ProgramTemplate] =
    [
        ProgramTemplate(title: "Stronglifts 5x5", workoutTemplates: [
            WorkoutTemplate.sampleWorkoutTemplates[0],
            WorkoutTemplate.sampleWorkoutTemplates[1],
        ])
    ]
}

struct WorkoutQueue: Codable {
    var selectedProgram: ProgramTemplate
    var nextWorkouts: [WorkoutTemplate]
    var currentIndex: Int // Tracks which workout is currently at the front of the queue

    init(selectedProgram: ProgramTemplate, nextWorkouts: [WorkoutTemplate], currentIndex: Int = 0) {
        self.selectedProgram = selectedProgram
        self.nextWorkouts = Array(selectedProgram.workoutTemplates.prefix(3)) //loop through selectedProgram.workoutTemplates
        //default behavior should to be increase weight every time an excercise is displayed
        //if FAILED is called, then the same workout template that was failed replaces the earliest instance of that same workoutType
        self.currentIndex = currentIndex
    }
}



// Users -> CompletedWorkout -> Workout_ID
struct CompletedWorkout: Codable, Identifiable {
    var id: String
    var workoutTemplateId: String
    var exercises: [Exercise]
}


struct Exercise: Codable, Identifiable {
    var id: String
    var title: String
    var sets: Int
    var reps: Int
    var weight: Float
    
    
    init(id: String = UUID().uuidString, title: String, sets: Int, reps: Int, weight: Float) {
        self.id = id
        self.title = title
        self.sets = sets
        self.reps = reps
        self.weight = weight

        
    }

    // LOGIC:
    
    // If all reps are done, then set is completed
    // If all sets are completed, then self.weight is increased by self.increments
    // Else, self.weight stays the same
    
    
}



