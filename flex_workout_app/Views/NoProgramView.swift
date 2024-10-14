//
//  NoProgramView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/11/24.
//

import SwiftUI

struct NoProgramView: View {
    var body: some View {
        VStack {
            Text("Please select a program")
                .foregroundColor(.gray)
                .italic()
        }
    }
}

#Preview {
    NoProgramView()
}
