//
//  SelectPlanView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/13/24.
//


import SwiftUI

struct SelectPlanView: View {
    @ObservedObject var viewModel: MainViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Select a starting program")
                .font(.title)
            Text("Don't worry, you can always change it later")
            
            ForEach(viewModel.programTemplates) { template in
                Button(action: {
                    viewModel.selectProgram(programId: template.id)
                }) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(template.title)
                            .font(.title2)
                            .bold()
                        ForEach(template.workoutTemplates) { workout in
                            Text("• \(workout.title)")
                                .font(.subheadline)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical)
        .onAppear {
            viewModel.fetchProgramTemplates()
        }
    }
}

#Preview {
    SelectPlanView(viewModel: MainViewModel())
}
