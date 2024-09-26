//
//  LoginView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/11/24.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = AuthenticationViewModel()
    @State private var showLoginFields = false
    @State private var showErrorBanner = false

    
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
                
                if showErrorBanner {
                    Text(viewModel.errorMessage)
                        .foregroundColor(.red)
                        .font(.system(size: 14))
                        .padding()
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                        .transition(.move(edge: .top).combined(with: .opacity)) // Slide from top & fade
                        .onAppear {
                            // Dismiss the banner after 3 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                withAnimation {
                                    showErrorBanner = false
                                }
                            }
                        }
                }
                
                if showLoginFields {
                    VStack(spacing: 10) {
                        TextField("Email", text: $viewModel.email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                        
                        SecureField("Password", text: $viewModel.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                }
            
                Button(action: {
                    if showLoginFields {
                        viewModel.signIn()
                    } else {
                        withAnimation {
                            showLoginFields.toggle()
                        }
                    }
                }) {
                    Text(showLoginFields ? "Log in" : "Sign in with email")
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
                
                NavigationLink(destination: RegisterView(viewModel: viewModel)) {
                    Text("Create Account")
                        .font(.system(size: 14))
                        .foregroundColor(.cyan)
                }
            }
            .padding()
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                MainView()
            }
        }
        .onAppear {
            viewModel.checkAuthentication()
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
