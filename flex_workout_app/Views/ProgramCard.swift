//
//  ProgramCard.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/3/24.
//

import SwiftUI

struct ProgramCard: View {
    let program: Program
    var isActive: Bool = false
    var isSelectable: Bool = false
    var tags: [String] = ["Strength & Size", "Beginner"]
    let onOpen: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if isActive {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.cyan)
                }
                Text(program.programName)
                    .font(.headline)
                Spacer()
                if !isSelectable {
                    Button(action: {
                        onOpen()
                    }, label: {
                        Image(systemName: "info.circle")
                            .foregroundColor(.cyan)
                    })
                }
            }
            
            // TAGS
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
        .onTapGesture {
            if isSelectable {
                onOpen()
            }
        }
    }
}

