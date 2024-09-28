//
//  WorkoutsView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/26/24.
//

import SwiftUI

struct WorkoutsView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    WorkoutList()
                    ScheduleButton()
                }
                .padding()
            }
            
        }
    }
}


struct WorkoutList: View {
    var body: some View {
        VStack(spacing: 0) {
            WorkoutRow(name: "Workout A", exercises: "Squat, Bench, BB Row")
            Divider().background(Color.gray.opacity(0.3))
            WorkoutRow(name: "Workout B", exercises: "Squat, OHP, Deadlift")
            Divider().background(Color.gray.opacity(0.3))
            Button(action: {}) {
                Text("Add Workout")
                    .foregroundColor(.cyan)
                    .padding(.vertical, 10)
            }
        }
        .background(Color.white)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        
    }
}

struct WorkoutRow: View {
    let name: String
    let exercises: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(name)
                    .font(.headline)
                Text(exercises)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct ScheduleButton: View {
    var body: some View {
        Button(action: {}) {
            HStack {
                Text("Schedule")
                    .foregroundColor(.cyan)
                Spacer()
                Text("3×/week")
                    .foregroundColor(.black)
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
        }
    }
}

struct WorkoutProgramView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutsView()
    }
}
