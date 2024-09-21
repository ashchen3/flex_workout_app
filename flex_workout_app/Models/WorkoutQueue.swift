//
//  WorkoutQueue.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/16/24.
//

import Foundation


struct WorkoutQueue: Codable {
    var workouts: [WorkoutTemplate]
    var lastUpdated: Date
    
    init(workouts: [WorkoutTemplate], lastUpdated: Date = Date()) {
        self.workouts = workouts
        self.lastUpdated = lastUpdated
    }
    
    //FUNCTIONS//
    
    //LOAD PROGRAM
    func loadProgram(program: String) {
        print("Loading \(program)")
    }
    
    //COMPLETE WORKOUT
    func advanceQueue() {
        //
    }
    
    
    
}


//
//struct WorkoutQueue: Codable {
//    var selectedProgram: ProgramTemplate
//    var nextWorkouts: [WorkoutTemplate]
//    var currentIndex: Int // Tracks which workout is currently at the front of the queue
//
//    init(selectedProgram: ProgramTemplate, nextWorkouts: [WorkoutTemplate], currentIndex: Int = 0) {
//        self.selectedProgram = selectedProgram
//        self.nextWorkouts = Array(selectedProgram.workoutTemplates.prefix(3)) //loop through selectedProgram.workoutTemplates
//        //default behavior should to be increase weight every time an excercise is displayed
//        //if FAILED is called, then the same workout template that was failed replaces the earliest instance of that same workoutType
//        self.currentIndex = currentIndex
//    }
//}



// Users -> CompletedWorkout -> Workout_ID
struct CompletedWorkout: Codable, Identifiable {
    var id: String
    var workoutTemplateId: String
    var exercises: [Exercise]
}


struct Exercise: Codable, Identifiable {
    var id: String
    var exerciseTypeId: String
    var sets: Int
    var reps: Int
    var weight: Float
    
    
    init(id: String = UUID().uuidString, exerciseTypeId: String, sets: Int, reps: Int, weight: Float) {
        self.id = id
        self.exerciseTypeId = exerciseTypeId
        self.sets = sets
        self.reps = reps
        self.weight = weight

        
    }

    // LOGIC:
    
    // If all reps are done, then set is completed
    // If all sets are completed, then self.weight is increased by self.increments
    // Else, self.weight stays the same
    
    
}
