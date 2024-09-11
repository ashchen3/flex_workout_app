//
//  HomeViewModel.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import Foundation

class HomeViewModel: ObservableObject {
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
}
