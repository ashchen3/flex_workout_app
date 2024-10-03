//MainViewModel.swift

import Foundation
import Supabase

class MainViewModel: ObservableObject {
    @Published var isAuthenticated = false
    
    private let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    init() {
        checkAuthenticationStatus()
    }
    
    func checkAuthenticationStatus() {
        Task {
            do {
                _ = try await supabase.auth.session
                await MainActor.run {
                    self.isAuthenticated = true
                }
            } catch {
                print("Error checking authentication status: \(error)")
                await MainActor.run {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    func signOut() {
        Task {
            do {
                try await supabase.auth.signOut()
                await MainActor.run {
                    self.isAuthenticated = false
                }
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }
}
