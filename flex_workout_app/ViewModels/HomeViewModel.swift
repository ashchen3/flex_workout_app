//
//  HomeViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import Foundation
import Supabase

class HomeViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    init() { }
    
    func fetchWorkouts(for programId: Int) async throws {
        let response: [Workout] = try await supabase
            .from("workouts")
            .select("*")
            .eq("program_id", value: programId)
            .order("workout_order", ascending: true)  // Sort by workout_order
            .execute()
            .value
        
        await MainActor.run {
            self.workouts = response
        }
    }
    
    func fetchProgramExercises(for workout: Workout) async throws -> [Exercise] {
        
        let response: [WorkoutExercise] = try await supabase
            .from("workout_exercises")
            .select("*, user_exercises(*)")
            .eq("workout_id", value: workout.id)
            .execute()
            .value
        
        let userExerciseIds = response.map { $0.user_exercise_id }
        
        let exercisesResponse: [Exercise] = try await supabase
            .from("user_exercises")
            .select("*")
            .in("id", values: userExerciseIds)
            .order("created_at", ascending: false)
            .execute()
            .value
        
        print("Fetching user exercises")
        
        return exercisesResponse
        
    }
}
