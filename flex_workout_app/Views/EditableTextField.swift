//
//  EditableTextField.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/2/24.
//

import SwiftUI

struct EditableTextField: View {
    @Binding var text: String
    @Binding var isEditing: Bool
    let placeholder: String
    let onSubmit: () -> Void
    
    var body: some View {
        HStack {
            if isEditing {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.title2)
                    .bold()
                    .disableAutocorrection(true)
                    .textInputAutocapitalization(.never)
            } else {
                Text(text)
                    .font(.title2)
                    .bold()
            }
            
            Button(action: {
                if isEditing {
                    onSubmit()
                }
                isEditing.toggle()
            }) {
                Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                    .foregroundColor(.cyan)
            }
        }
    }
}


