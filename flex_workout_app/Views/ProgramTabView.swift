//
//  ProgramTabView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct ProgramTabView: View {
    @State private var selectedSegment = 0
    let segments = ["Program", "Workouts", "Exercises"]
    
    var body: some View {
        VStack {
            Picker("Select", selection: $selectedSegment) {
                ForEach(0..<3) { index in
                    Text(self.segments[index])
                        .tag(index)
                }
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())

            Spacer()

            // Display the view based on the selected segment
            if selectedSegment == 0 {
                ProgramView()
            } else if selectedSegment == 1 {
                WorkoutsView()
            } else if selectedSegment == 2 {
                ExercisesView()
            } 

            Spacer()
        }
    }
}


#Preview {
    ProgramTabView()
        .environmentObject(UserState())
}
