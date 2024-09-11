//
//  LoginViewModel.swift
//  Flex
//
//  Created by Alex Chen on 9/4/24.
//

import FirebaseAuth
import Foundation

class LoginViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage = ""
    
    init() {}
    
    func login() {
        guard validate() else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    func continueAsGuest() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            self.isAuthenticated = true
        }
    }
    
    private func validate() -> Bool {
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
}
