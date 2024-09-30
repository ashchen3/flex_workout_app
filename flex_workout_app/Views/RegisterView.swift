//
//  RegisterView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct RegisterView: View {
    @ObservedObject var viewModel: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var showErrorBanner = false
    
    var body: some View {
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
            
            if showErrorBanner {
                ErrorBanner(message: viewModel.errorMessage, isPresented: $showErrorBanner)
            }
            
            VStack(spacing: 10) {
                TextField("Name", text: $viewModel.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.words)
                
                TextField("Email", text: $viewModel.email)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                
                SecureField("Password", text: $viewModel.password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                SecureField("Confirm Password", text: $viewModel.confirmPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            
            Button(action: {
                viewModel.signUp()
                showErrorBanner = !viewModel.errorMessage.isEmpty
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.cyan)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Back")
                    .font(.system(size: 14))
                    .foregroundColor(.cyan)
            }
        }
        .padding()
        .onAppear {
            viewModel.onSuccessfulRegistration = {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView(viewModel: AuthenticationViewModel())
    }
}
