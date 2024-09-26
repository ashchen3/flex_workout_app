//
//  ProfileView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    
    var body: some View {
        VStack {
            Text("Profile View")
            
            Button("Log Out") {
                mainViewModel.signOut()
            }
            .tint(.red)
            .padding()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(MainViewModel())
    }
}
