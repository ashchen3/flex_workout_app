//  MAIN FUNCTIONALITY PAGE
//  MainView.swift
//  Flex
//
//  Created by Alex Chen on 9/4/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewModel()
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty {
            if let selectedProgramId = viewModel.selectedProgramId {
                accountView(selectedProgramId: selectedProgramId)
            } else {
                SelectPlanView(viewModel: viewModel)
            }
        } else {
            LoginView()
        }
    }
    
    @ViewBuilder
    func accountView(selectedProgramId: String) -> some View {
        TabView {
            HomeView(userId: viewModel.currentUserId)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
