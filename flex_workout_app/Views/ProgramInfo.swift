//
//  ProgramInfo.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/2/24.
//

import SwiftUI

struct ProgramInfo: View {
    let program: Program
    @State private var editedName: String
    @State private var isEditing = false
    @State private var showDeleteAlert = false
    @StateObject private var viewModel: ProgramViewModel
    @Environment(\.presentationMode) var presentationMode
    
    init(program: Program, viewModel: ProgramViewModel) {
        self.program = program
        self._editedName = State(initialValue: program.programName)
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        VStack {
            HStack {
                if isEditing {
                    TextField("Program Name", text: $editedName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .font(.title2)
                        .bold()
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                } else {
                    Text(program.programName)
                        .font(.title2)
                        .bold()
                }
                
                Button(action: {
                    if isEditing {
                        Task {
                            await viewModel.updateProgram(program, with: editedName)
                            try await viewModel.fetchPrograms()
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                    isEditing.toggle()
                }) {
                    Image(systemName: isEditing ? "checkmark.circle.fill" : "pencil.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color(UIColor.systemGray6))
            
            Text("You created this program.")
                .frame(alignment: .leading)
                .padding()
            
            Button(action: {
                showDeleteAlert = true
            }) {
                Text("Delete Program")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .alert(isPresented: $showDeleteAlert) {
                Alert(
                    title: Text("Delete Program"),
                    message: Text("Are you sure you want to delete this program?"),
                    primaryButton: .destructive(Text("Delete")) {
                        Task {
                            if let id = program.id {
                                do {
                                    try await viewModel.deleteProgram(at: id)
                                    try await viewModel.fetchPrograms()
                                    presentationMode.wrappedValue.dismiss()
                                } catch {
                                    print("Error deleting program: \(error)")
                                }
                            }
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
            
            Spacer()
        }
        .padding()
    }
}

