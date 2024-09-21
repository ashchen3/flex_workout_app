//
//  HomeView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import FirebaseFirestore
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    let workouts: [WorkoutTemplate]

    
    init(userId: String, workouts: [WorkoutTemplate] = WorkoutTemplate.sampleWorkoutTemplates) {
        self._viewModel = StateObject(
            wrappedValue: HomeViewModel(userId: userId)
        )
        self.workouts = workouts
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Flex")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundColor(.cyan)
                
                List(workouts) { workout in
                    NavigationLink(destination: InWorkoutView(workout: workout)) {
                            WorkoutCardView(workout: workout, isTopCard: workout.id == workouts.first?.id)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        
    }
    
}

//#Preview {
//    HomeView()
//}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(userId: "LhvfJa6jNqegPQbsQRFmraO7Env2")
    }
}
