//MainViewModel.swift

import Foundation
import Supabase

struct Profile: Identifiable, Codable {
    let id: UUID
    let createdAt: Date
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case name
    }
}

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
