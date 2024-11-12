//
//  HomeView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var viewModel = WorkoutsViewModel()
    @EnvironmentObject var userState: UserState
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path){
            VStack {
                Text("Flex")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundColor(.cyan)
                if let profile = userState.profile {
                    //Text("Program ID: \(selectedId)")
                    List {
                        ForEach(viewModel.workoutsWithExercises) { workoutWithExercises in
                            Button {
                                path.append(workoutWithExercises)
                            } label: {
                                WorkoutCardView(workoutWithExercises: workoutWithExercises, isTopCard: true)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
                Spacer()
            }
            .navigationDestination(for: WorkoutWithExercises.self) { workoutWithExercises in
                InWorkoutView(workoutWE: workoutWithExercises)
            }
            .task {
                try? await userState.fetchProfile()
                if let programId = userState.profile?.selectedProgram {
                    try? await viewModel.fetchWorkoutsWithExercises(for: programId)
                }
            }
        }
            
    }
}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(UserState())
    }
}
