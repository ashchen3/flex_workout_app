//
//  PopupView.swift
//  flex_workout_app
//
//  Created by Alex Chen on 10/2/24.
//

import SwiftUI

// Model for each item (can represent database items)
struct SheetItem: Identifiable {
    let id: String
    let title: String
    let content: String
}

struct PopupView: View {
    @State private var activeSheet: SheetItem?
    
    
    let items: [SheetItem] = [
        SheetItem(id: "1", title: "View Settings", content: "Hello Worldie"),
        SheetItem(id: "2", title: "View Second Button", content: "Oh No!"),
        SheetItem(id: "3", title: "View Third Button", content: "Third Screen!")
    ]

    var body: some View {
        VStack {
            ForEach(items) { item in
                Button(item.title) {
                    activeSheet = item
                }
                Spacer()
            }
        }
        .sheet(item: $activeSheet) { item in
            SettingsView(text: item.content)
                .presentationDetents([.fraction(3/4)])
                .presentationCompactAdaptation(.none)
        }
        .padding()
    }
}

struct SettingsView: View {
    let text: String

    var body: some View {
        Text(text)
    }
}




#Preview {
    PopupView()
}
