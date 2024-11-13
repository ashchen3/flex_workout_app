//
//  TableStructs.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/22/24.
//

import Foundation

struct Profile: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    let name: String?
    let email: String?
    let selectedProgram: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
        case email
        case selectedProgram = "selected_program"
    }
}

struct Program: Identifiable, Codable {
    var id: Int?
    var user_id: UUID
    var programName: String
    var createdAt: Date?
    var numWorkouts: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case programName = "program_name"
        case createdAt = "created_at"
        case numWorkouts = "num_workouts"
    }
}

struct Workout: Identifiable, Codable, Equatable, Hashable {
    var id: Int? //To be populated by Supabase
    var user_id: UUID
    var workoutName: String
    var programId: Int
    var workoutOrder: Int? //also populated by Supabase? and/or iterated upon after creation
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case workoutName = "workout_name"
        case programId = "program_id"
        case workoutOrder = "workout_order"
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id &&
            lhs.user_id == rhs.user_id &&
            lhs.workoutName == rhs.workoutName &&
            lhs.programId == rhs.programId &&
            lhs.workoutOrder == rhs.workoutOrder
    }
}

struct Exercise: Identifiable, Codable, Hashable {
    var id: Int? //To be populated by Supabase
    var user_id: UUID?
    var exerciseName: String
    var defaultWeight: Float
    var defaultReps: Int
    var defaultSets: Int
    var increment: Float?
    var incrementFreq: Int?
    var deload: Float?
    var deloadFreq: Int?
    var currentWeight: Float?
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case exerciseName = "exercise_name"
        case defaultWeight = "default_weight"
        case defaultReps = "default_reps"
        case defaultSets = "default_sets"
        case increment
        case incrementFreq = "increment_freq"
        case deload
        case deloadFreq = "deload_freq"
        case currentWeight = "current_weight"
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
    }
    
    static func == (lhs: Exercise, rhs: Exercise) -> Bool {
        return lhs.id == rhs.id &&
            lhs.user_id == rhs.user_id &&
            lhs.exerciseName == rhs.exerciseName &&
            lhs.defaultWeight == rhs.defaultWeight &&
            lhs.defaultReps == rhs.defaultReps &&
            lhs.defaultSets == rhs.defaultSets &&
            lhs.increment == rhs.increment &&
            lhs.incrementFreq == rhs.incrementFreq &&
            lhs.deload == rhs.deload &&
            lhs.deloadFreq == rhs.deloadFreq &&
            lhs.currentWeight == rhs.currentWeight
    }
    
}

struct WorkoutExercise: Codable, Identifiable {
    var id: Int?
    var workout_id: Int
    var exercise_id: Int
    var user_exercise_id: Int
    var user_id: UUID
    var exercises: Exercise?

}

struct WorkoutWithExercises: Identifiable, Hashable {
    let workout: Workout
    var exercises: [Exercise]
    
    var id: Int? { workout.id }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id ?? 0)  // hash just based on ID
    }

    static func == (lhs: WorkoutWithExercises, rhs: WorkoutWithExercises) -> Bool {
        return lhs.workout == rhs.workout && lhs.exercises == rhs.exercises
    }
}


struct LoggedExerciseSet: Codable, Identifiable, Equatable {
    var id: Int?
    var program_id: Int?
    var user_exercise_id: Int
    var user_exercise_name: String?
    var setNumber: Int
    var repsCompleted: Int
    var weight: Float
    var createdAt: Date
    var user_id: UUID
    
    enum CodingKeys: String, CodingKey {
        case id
        case program_id
        case user_exercise_id
        case user_exercise_name
        case setNumber = "set_number"
        case repsCompleted = "reps_completed"
        case weight
        case createdAt = "created_at"
        case user_id
    }
}



///////////////////////////////////////////////////
///THINGS IN USE ABOVE THIS LINE
///////////////////////////////////////////////////


struct RoutineHistory: Codable {
    let id: Int
    let personID: UUID
    let programID: Int
    let routineID: Int
    let dateStarted: Date
    let dateCompleted: Date?
    let isCompleted: Bool
}




