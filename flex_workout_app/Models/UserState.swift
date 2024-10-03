//
//  UserState.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/24/24.
//

import Foundation
import Supabase

class UserState: ObservableObject {
    @Published var currentUserId: UUID?
    @Published var profile: Profile?
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    func updateUserId() async throws {
        let user = try await supabase.auth.session.user

        self.currentUserId = user.id
    }
    
    @MainActor
    func fetchProfile() async throws {
        let user = try await supabase.auth.session.user
        
        let profile: Profile = try await supabase
            .from("profiles")
            .select()
            .eq("id", value: user.id)
            .single()
            .execute()
            .value
        
        self.profile = profile
    }
}
