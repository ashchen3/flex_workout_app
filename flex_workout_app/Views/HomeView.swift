//
//  HomeView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var userState: UserState
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Flex")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundColor(.cyan)
                if let profile = userState.profile {
                    if let selectedId = profile.selectedProgram {
                        Text("Program ID: \(selectedId)")
                    }
                    
                }
                
                Spacer()
            }
        }
        
    }
    
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
