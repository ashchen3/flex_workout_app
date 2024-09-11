//
//  LoginView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    @State private var showLoginFields = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                HStack(spacing: 0) {
                    Text("Welcome to ")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Flex.")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .italic()
                        .foregroundColor(.cyan)
                }
                
                if showLoginFields {
                    VStack(spacing: 10) {
                        TextField("Email", text: $viewModel.email)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                                .autocapitalization(.none)
                                            
                        SecureField("Password", text: $viewModel.password)
                                                .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            
                Button(action: {
                    if showLoginFields {
                        viewModel.login()
                    } else {
                        withAnimation {
                            showLoginFields.toggle()
                        }
                    }
                }) {
                    Text("Log in")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.cyan)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    viewModel.continueAsGuest()
                }) {
                    Text("Continue as Guest")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: RegisterView(loginIsAuthenticated: $viewModel.isAuthenticated)) {
                                    Text("Create Account")
                                        .font(.system(size: 14))
                                        .foregroundColor(.cyan)
                                }

                
            }
            .padding()
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                HomeView()
            }
        }
        }
            
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
