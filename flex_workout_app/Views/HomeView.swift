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
    //static var workouts = Workout.sampleData //temp var
    //let workouts: [WorkoutTemplate]
    
    
    //@FirestoreQuery var workoutQueue: next three workouts
    
    init(userId: String) {
        self._viewModel = StateObject(
            wrappedValue: HomeViewModel(userId: userId)
        )
    }
    
    var body: some View {
        VStack {
            Text("Flex")
                .font(.title)
                .fontWeight(.bold)
                .italic()
                .foregroundColor(.cyan)
            
//            List(workouts) { workout in
//                WorkoutCardView(workout: workout, isTopCard: workout.id == workouts.first?.id)
//            }
//            .listStyle(PlainListStyle())
               
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
