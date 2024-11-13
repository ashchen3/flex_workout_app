//  MAIN FUNCTIONALITY PAGE
//  MainView.swift
//  Flex
//
//  Created by Alex Chen on 9/4/24.
//

import SwiftUI


struct MainView: View {
    @StateObject private var mainViewModel = MainViewModel()
    @StateObject private var userState = UserState()
    
    var body: some View {
        Group {
            if mainViewModel.isAuthenticated {
                TabView {
                    HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                    HistoryView()
                        .tabItem {
                            Label("History", systemImage: "chart.xyaxis.line")
                        }
                    ProgramTabView()
                        .tabItem {
                            Label("Program", systemImage: "flame")
                        }
                    ProfileView()
                        .tabItem {
                            Label("Profile", systemImage: "person.circle")
                        }
                }
            } else {
                LoginView()
            }
        }
        .environmentObject(mainViewModel)
        .environmentObject(userState)
        .onAppear {
            mainViewModel.checkAuthenticationStatus()
            Task {
                try await userState.updateUserId()
                try await userState.fetchProfile()
            }
        }
    }
}

#Preview {
    MainView()
}
