//
//  UserState.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/24/24.
//

import Foundation
import Supabase

class UserState: ObservableObject {
    @Published var currentUserId: String = ""
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    func updateUserId() {
        Task {
            do {
                let user = try await supabase.auth.session.user
                await MainActor.run {
                    self.currentUserId = user.id.uuidString
                }
            } catch {
                print("Error updating user ID: \(error)")
            }
        }
    }
}
