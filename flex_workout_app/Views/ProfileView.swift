//
//  ProfileView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        VStack {
            Text("Profile View")
            
            if let profile = userState.profile {
                Text("Account created on:")
                Text(profile.createdAt, style: .date)
                
                if let name = profile.name {
                    Text("Name:")
                    Text(name)
                }
            } else {
                Text("Loading profile...")
            }
            
            
            Button("Log Out") {
                mainViewModel.signOut()
            }
            .tint(.red)
            .padding()
        }
        .onAppear {
            if userState.profile == nil {
                Task {
                    await userState.fetchProfile()
                }
            }
        }
    }
}




struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(MainViewModel())
            .environmentObject(UserState()) 
    }
}
