//
//  HistoryViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 11/12/24.
//

import Foundation
import Supabase


class HistoryViewModel: ObservableObject {
    
    @Published var loggedSets: [LoggedExerciseSet] = []
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    
    func getHistory() async throws {
        let response: [LoggedExerciseSet] = try await supabase
            .rpc("get_ranked_exercise_sets")
            .execute()
            .value
            
        print(response)
        DispatchQueue.main.async {
            self.loggedSets = response
        }
    }
    
}
