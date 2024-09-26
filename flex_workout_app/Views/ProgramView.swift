//
//  ProgramView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/24/24.
//

import SwiftUI


struct ProgramView: View {

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {            
                
                // Content
                ScrollView {
                    VStack(spacing: 16) {
                        Text("ACTIVE PROGRAM")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                        
                        ProgramCard(name: "Stronglifts 5×5", isActive: true, tags: ["Strength & Size", "Beginner"])
                        ProgramCard(name: "Stronglifts 5×5 Lite", tags: ["Limited Time", "Recovery", "Beginner", "Intermedia"])
                        ProgramCard(name: "Stronglifts 5×5 Mini", tags: ["Maintenance", "Beginner", "Intermediate"])
                        ProgramCard(name: "Stronglifts 5×5 Plus", tags: ["Hypertrophy", "Beginner", "Intermediate"])
                        ProgramCard(name: "Stronglifts 5×5 Ultra", tags: ["Strength & Size", "Beginner", "Intermediate"])
                    }
                    .padding(.vertical)
                }
            }
            .foregroundColor(.black)
            .background(Color.white.edgesIgnoringSafeArea(.all))
        }
    }
}

struct ProgramCard: View {
    let name: String
    var isActive: Bool = false
    let tags: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.cyan)
                }
                Text(name)
                    .font(.headline)
                Spacer()
                Image(systemName: "info.circle")
                    .foregroundColor(.cyan)
            }
            
            HStack {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(8)
                }
            }
        }
        .padding()
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}

struct ProgramView_Previews: PreviewProvider {
    static var previews: some View {
        ProgramView()
    }
}
