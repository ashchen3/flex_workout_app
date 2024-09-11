//
//  RegisterView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct RegisterView: View {
    @StateObject var viewModel = RegisterViewModel()
    @Environment(\.presentationMode) var presentationMode
    @Binding var loginIsAuthenticated: Bool

    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    Text("Create your ")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("Flex ")
                        .font(.title)
                        .fontWeight(.bold)
                        .italic()
                        .foregroundColor(.cyan)
                    
                    Text("Account")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                VStack(spacing: 10) {
                    if !viewModel.errorMessage.isEmpty {
                        Text(viewModel.errorMessage)
                            .foregroundColor(.red)
                            .font(.system(size: 10))
                    }
                    TextField("Name", text: $viewModel.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    TextField("Email", text: $viewModel.email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    SecureField("Password", text: $viewModel.password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Button(action: {
                    viewModel.register()
                }) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()  // Go back to the previous view
                }) {
                    Text("Back")
                        .font(.system(size: 14))
                        .foregroundColor(.cyan)
                }
                
            }
            .padding()
        }
        .onAppear {
                    viewModel.onSuccessfulRegistration = {
                        loginIsAuthenticated = true
                    }
                }
    }
}

struct RegisterView_Previews: PreviewProvider {
    @State static var dummyIsAuthenticated = false
    
    static var previews: some View {
        RegisterView(loginIsAuthenticated: $dummyIsAuthenticated)
    }
}
