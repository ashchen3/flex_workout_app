//
//  ProgramTabView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct ProgramTabView: View {
    @State private var selectedSegment = 0
    let segments = ["Program", "Workouts", "Weights", "Sets×Reps"]
    
    var body: some View {
        NavigationView{
            VStack {
                Picker("Select", selection: $selectedSegment) {
                    ForEach(0..<segments.count) { index in
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
                    WeightsView()
                } else if selectedSegment == 3 {
                    SetsRepsView()
                }

                Spacer()
            }
            .navigationTitle("Programs") // Set the title
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) 
                {
                    Text("Programs")
                        .font(.headline)
                        .frame(alignment: .center) // Center aligned
                }

                // Trailing toolbar item
                ToolbarItem(placement: .navigationBarTrailing) 
                {
                    Button(action: {
                        // Action for Create button
                    }) {
                        Text("Create")
                            .foregroundColor(.cyan)
                    }
                }
            }
        }
        
    }
}

#Preview {
    ProgramTabView()
}
