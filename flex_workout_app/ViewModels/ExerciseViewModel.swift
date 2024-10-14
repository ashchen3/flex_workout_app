//
//  ExerciseViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/12/24.
//

import Foundation
import Supabase

class ExerciseViewModel: ObservableObject {
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    func updateExercise(_ exercise: Exercise) async throws {
        guard let id = exercise.id else {
            print("Can't update exercise: No ID")
            return
        }
        
        do {
            try await supabase
                .from("user_exercises")
                .update(exercise)
                .eq("id", value: id)
                .execute()
        } catch {
            print("Error updating exercise: \(error)")
            throw error
        }
    }
}
