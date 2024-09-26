//
//  AuthenticationViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/22/24.
//

import Foundation
import Supabase

class AuthenticationViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated = false
    
    var onSuccessfulRegistration: (() -> Void)?

    
    let supabase = SupabaseClient(supabaseURL: Secrets.projectURL, supabaseKey: Secrets.apiKey)
    
    // MARK: - Authentication
    
    func signUp() {
        Task {
            do {
                guard validateSignUp() else { return }
                _ = try await supabase.auth.signUp(email: email, password: password)
                await MainActor.run {
                    self.isAuthenticated = true
                    self.onSuccessfulRegistration?()
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Sign up failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func signIn() {
        Task {
            do {
                guard validateSignIn() else { return }
                _ = try await supabase.auth.signIn(email: email, password: password)
                await MainActor.run {
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Sign in failed: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func continueAsGuest() {
        Task {
            do {
                _ = try await supabase.auth.signInAnonymously()
                await MainActor.run {
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "Guest sign in failed: \(error.localizedDescription)"
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
                print("Sign out failed: \(error)")
            }
        }
    }
    
    func checkAuthentication() {
        Task {
            do {
                _ = try await supabase.auth.session.user
                await MainActor.run {
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.isAuthenticated = false
                }
            }
        }
    }
    
    
    private func validateSignIn() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "*please enter your email and password"
            
            return false
        }
        
        guard Helper.validateEmail(enteredEmail: email) else {
            errorMessage = "please enter valid email address"
            return false
        }
        return true
    }
    
    private func validateSignUp() -> Bool {
        errorMessage = ""
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty
        else {
            errorMessage = "please fill out all fields"

            return false
        }
        guard Helper.validateEmail(enteredEmail: email) else {
            errorMessage = "please enter valid email address"
            return false
        }
        guard password.count >= 6 else {
            errorMessage = "password must be 6 characters or more"
            return false
        }
        guard password == confirmPassword else {
            errorMessage = "passwords must match"
            return false
        }
        
        return true
    }
    
}
