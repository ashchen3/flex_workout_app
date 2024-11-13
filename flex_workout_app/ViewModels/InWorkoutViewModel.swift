//
//  InWorkoutViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import Foundation
import Supabase


class InWorkoutViewModel: ObservableObject {

    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)

//    exerciseCompletedSets = [
//        1: [5, 5, nil, 4, 5],     // Exercise ID 1 (maybe Squat)
//        2: [8, 8, 8, nil, nil],   // Exercise ID 2 (maybe Bench Press)
//        3: [12, 10, nil, nil, nil] // Exercise ID 3 (maybe Deadlift)
//    ]
    
//    struct LoggedExerciseSet: Codable, Identifiable {
//        var id: Int?
//        var program_id: Int?
//        var user_exercise_id: Int
//        var setNumber: Int
//        var repsCompleted: Int
//        var weight: Float
//        var createdAt: Date
//        var user_id: UUID
    
    func logCompletedSets(exerciseCompletedSets: [Int: [Int?]]) async throws {
        let user = try await supabase.auth.session.user
        
        for (exerciseId, completedSets) in exerciseCompletedSets {
            let user_exercises: [Exercise] = try await supabase
                .from("user_exercises")
                .select()
                .eq("id", value: exerciseId)
                .execute()
                .value
            
            guard let user_exercise = user_exercises.first else {
                throw NSError(domain: "ExerciseError",
                             code: 404,
                             userInfo: [NSLocalizedDescriptionKey: "Exercise not found"])
            }
            // Loop through each set in the completedSets array
            for (setIndex, reps) in completedSets.enumerated() {
                if let reps = reps {  // Only log sets that aren't nil
                    
                    try await supabase.from("logged_exercise_set")
                        .insert(LoggedExerciseSet(
                            //program_id: exerciseId,
                            user_exercise_id: exerciseId,
                            setNumber: setIndex + 1,
                            repsCompleted: reps, //fetch Exercise using exercise ID for weight
                            weight: user_exercise.currentWeight ?? user_exercise.defaultWeight,
                            createdAt: Date(),
                            user_id: user.id
                        ))
                        .execute()
                }
            }
            try await checkAndUpdateWeight(exerciseId: exerciseId,
                                           completedSets: completedSets,
                                           exercise: user_exercise)
        }
    }
    
    func checkAndUpdateWeight(exerciseId: Int, completedSets: [Int?], exercise: Exercise) async throws {
        // Check if all sets are completed with required reps
        let allSetsCompleted = completedSets.allSatisfy { reps in
            if let reps = reps {
                return reps >= exercise.defaultReps
            }
            return false
        }
        
        if allSetsCompleted {
            // Calculate new weight
            let currentWeight = exercise.currentWeight ?? exercise.defaultWeight
            let newWeight = currentWeight + (exercise.increment ?? 0)
            
            // Update the exercise with new weight
            try await supabase.from("user_exercises")
                .update(["current_weight": newWeight])
                .eq("id", value: exerciseId)
                .execute()
            
            print("updating with new weight: \(newWeight)")
        }
    }
    
    
    
}
