//
//  ErrorBannerView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 9/30/24.
//

import SwiftUI

struct ErrorBanner: View {
    let message: String
    @Binding var isPresented: Bool
    
    var body: some View {
        Text(message)
            .foregroundColor(.red)
            .font(.system(size: 14))
            .padding()
            .background(Color.red.opacity(0.1))
            .cornerRadius(8)
            .transition(.move(edge: .top).combined(with: .opacity))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    withAnimation {
                        isPresented = false
                    }
                }
            }
    }
}
