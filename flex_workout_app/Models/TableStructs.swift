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

struct Person: Codable {
    let id: UUID
    let created_at: Date
}



struct Routine: Codable {
    let id: Int
    let created_at: Date
    let routineName: String
    let description: String?
}

struct RoutineExercise: Codable {
    let id: Int
    let routineID: Int
    let exerciseID: Int
    let sets: Int
}

struct Exercise: Codable {
    let id: Int
    let exerciseName: String
    let description: String?
    let defaultReps: Int
    let defaultSets: Int
    let defaultWeight: Double
}
