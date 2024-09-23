//
//  TableStructs.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/22/24.
//

import Foundation

struct RoutineHistory: Codable {
    let id: Int
    let personID: UUID
    let programID: Int
    let routineID: Int
    let dateStarted: Date
    let dateCompleted: Date?
    let isCompleted: Bool
}

struct PersonProgramExerciseSets: Codable {
    let id: Int
    let personProgramExerciseID: Int
    let setNumber: Int
    let repsCompleted: Int
    let weight: Double
    let isCompleted: Bool
}

struct PersonProgramExercises: Codable {
    let id: Int
    let created_at: Date
    let personProgramID: Int
    let exerciseID: Int
    let routineID: Int
    let isCompleted: Bool
    let routineHistoryID: Int
}

struct PeoplePrograms: Codable {
    let id: Int
    let personID: UUID
    let programID: Int
}

struct ProgramRoutines: Codable {
    let id: Int
    let programID: Int
    let routineID: Int
    let routineOrder: Int
}

struct People: Codable {
    let id: UUID
    let created_at: Date
}

struct Programs: Codable {
    let id: Int
    let programName: String
    let description: String?
}

struct Routines: Codable {
    let id: Int
    let created_at: Date
    let routineName: String
    let description: String?
}

struct RoutineExercises: Codable {
    let id: Int
    let routineID: Int
    let exerciseID: Int
    let sets: Int
}

struct Exercises: Codable {
    let id: Int
    let exerciseName: String
    let description: String?
    let defaultReps: Int
    let defaultSets: Int
    let defaultWeight: Double
}
