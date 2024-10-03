//
//  HomeView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = ProgramViewModel()
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Flex")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundColor(.cyan)
                if let text = viewModel.selectedProgram?.programName {
                    Text(text)
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
