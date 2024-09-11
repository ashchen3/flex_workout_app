//
//  RegisterViewModel.swift
//  Flex
//
//  Created by Alex Chen on 9/11/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class RegisterViewModel: ObservableObject {
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage = ""
    @Published var isAuthenticated = false

    var onSuccessfulRegistration: (() -> Void)?
    
    init() {}
    
    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = error.localizedDescription
                return
            }
            
            guard let userId = result?.user.uid else {
                self.errorMessage = "Failed to get user ID"
                return
            }
            
            self.insertUserRecord(id: userId)
            self.isAuthenticated = true
            self.onSuccessfulRegistration?()
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        db.collection("users")
            .document(id)
            .setData(newUser.asDictionary())
    }
    
    private func validate() -> Bool {
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
