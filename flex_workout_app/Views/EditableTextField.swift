//
//  EditableTextField.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/2/24.
//

import SwiftUI

struct EditableTextField: View {
    @Binding var text: String
    @State private var isEditing = false
    let placeholder: String
    
    var body: some View {
        HStack {
            if isEditing {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .animation(.easeInOut, value: isEditing)
            } else {
                Text(text.isEmpty ? placeholder : text)
                    .foregroundColor(text.isEmpty ? .gray : .primary)
            }
            
            Spacer()
            
            Button(action: {
                withAnimation {
                    isEditing.toggle()
                }
            }) {
                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                    .foregroundColor(.cyan)
                    .font(.system(size: 20))
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct EditableTextField_Previews: PreviewProvider {
    static var previews: some View {
        EditableTextField(text: .constant("Sample Text"), placeholder: "Enter text here")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
