//
//  LoginViewModel.swift
//  Flex
//
//  Created by Alex Chen on 9/4/24.
//

import FirebaseFirestore
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
        
        self.isAuthenticated = true
    }
    
    func continueAsGuest() {
        Auth.auth().signInAnonymously { [weak self] authResult, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let userId = authResult?.user.uid else {
                self.errorMessage = "Failed to get user ID"
                return
            }
            
            self.insertAnonymousUserRecord(id: userId)
            
            self.isAuthenticated = true
        }
        
    }
    
    private func insertAnonymousUserRecord(id: String) {
        let newUser = User(id: id,
                           name: nil,     // No name for anonymous users
                           email: nil,    // No email for anonymous users
                           joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary()) { error in
                        if let error = error {
                            print("Error writing user to Firestore: \(error.localizedDescription)")
                        } else {
                            print("User added successfully to Firestore.")
                        }
                    }
        
        addDefaultTemplates(userId: id)
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
