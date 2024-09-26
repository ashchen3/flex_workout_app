//
//  HomeView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Flex")
                    .font(.title)
                    .fontWeight(.bold)
                    .italic()
                    .foregroundColor(.cyan)
                
                
                
                
                
//                List(workouts) { workout in
//                    NavigationLink(destination: InWorkoutView(workout: workout)) {
//                            WorkoutCardView(workout: workout, isTopCard: workout.id == workouts.first?.id)
//                    }
//                }
//                .listStyle(PlainListStyle())
            }
        }
        
    }
    
}

//#Preview {
//    HomeView()
//}


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
