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
    @Published var profile: Profile?
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    func updateUserId() {
        Task {
            do {
                let user = try await supabase.auth.session.user
                await MainActor.run {
                    self.currentUserId = user.id.uuidString
                }
                await fetchProfile()
            } catch {
                print("Error updating user ID: \(error)")
            }
        }
    }
    
    @MainActor
    func fetchProfile() async {
        do {
            let profile: Profile = try await supabase
                .from("profiles")
                .select()
                .eq("id", value: UUID(uuidString: currentUserId))
                .single()
                .execute()
                .value
            
            self.profile = profile
        } catch {
            print("Error fetching profile: \(error)")
        }
    }
}
