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
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case programName = "program_name"
        case createdAt = "created_at"
    }
}

struct Workout: Identifiable, Codable, Equatable {
    var id: Int? //To be populated by Supabase
    var user_id: UUID
    var workoutName: String
    var programId: Int
//    var workoutOrder: Int? //also populated by Supabase? and/or iterated upon after creation
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case workoutName = "workout_name"
        case programId = "program_id"
//        case workoutOrder = "workout_order"
    }
    
    static func == (lhs: Workout, rhs: Workout) -> Bool {
        return lhs.id == rhs.id &&
            lhs.user_id == rhs.user_id &&
            lhs.workoutName == rhs.workoutName &&
            lhs.programId == rhs.programId 
//                lhs.workoutOrder == rhs.workoutOrder
            
    }
}



struct Exercise: Identifiable, Codable, Hashable {
    var id: Int? //To be populated by Supabase
    var exerciseName: String
    var defaultWeight: Double
    var defaultReps: Int
    var defaultSets: Int
    var user_id: UUID?
    var increment: Float?
    var incrementFreq: Int?
    var deload: Float?
    var deloadFreq: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case exerciseName = "exercise_name"
        case defaultWeight = "default_weight"
        case defaultReps = "default_reps"
        case defaultSets = "default_sets"
        case user_id
        case increment
        case incrementFreq = "increment_freq"
        case deload
        case deloadFreq = "deload_freq"
    }
    
    func hash(into hasher: inout Hasher) {
         hasher.combine(id)
     }
}

struct WorkoutExercise: Codable, Identifiable {
    var id: Int?
    var workout_id: Int
    var exercise_id: Int
    var user_id: UUID
    var exercises: Exercise?
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

struct PersonProgramExerciseSet: Codable {
    let id: Int
    let personProgramExerciseID: Int
    let setNumber: Int
    let repsCompleted: Int
    let weight: Double
    let isCompleted: Bool
}

struct PersonProgramExercise: Codable {
    let id: Int
    let created_at: Date
    let personProgramID: Int
    let exerciseID: Int
    let routineID: Int
    let isCompleted: Bool
    let routineHistoryID: Int
}

struct PeopleProgram: Codable {
    let id: Int
    let personID: UUID
    let programID: Int
}

struct ProgramRoutine: Codable {
    let id: Int
    let programID: Int
    let routineID: Int
    let routineOrder: Int
}


struct RoutineExercise: Codable {
    let id: Int
    let routineID: Int
    let exerciseID: Int
    let sets: Int
}


