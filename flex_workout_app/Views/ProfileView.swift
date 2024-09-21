//
//  ProfileView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            Text("Profile View")
            
            Button("Log Out") {
                viewModel.logout()
            }
            .tint(.red)
            .padding()
        }
        
    }
}

#Preview {
    ProfileView()
}
