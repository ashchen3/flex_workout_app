//
//  ProfileViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/15/24.
//

import FirebaseAuth
import Foundation

class ProfileViewModel: ObservableObject {
    init() {}
    
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
        }
    }
}


