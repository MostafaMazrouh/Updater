//
//  LiveUpdatesView.swift
//  Updater
//
//  Created by Mostafa Mazrouh on 2024-11-17.
//

import SwiftUI

struct LiveUpdatesView: View {
    
    @ObservedObject var liveUpdatesVM = LiveUpdatesVM()
    
    var body: some View {
        VStack(alignment: .center) {
            SmallView(title: "Combine",
                      stock: liveUpdatesVM.combineKeywords,
                      currentVlaue: liveUpdatesVM.combineCurrent
            )
            .onTapGesture {
                liveUpdatesVM.updateCombineCurrent()
            }
            
            SmallView(title: "Swift concurrency",
                      stock: liveUpdatesVM.concurrencyKeywords,
                      currentVlaue: liveUpdatesVM.concurrencyCurrent
            )
            .onTapGesture {
                liveUpdatesVM.updateConcurrencyCurrent()
            }
        }
    }
}

struct SmallView: View {
    
    var title: String
    var stock: String
    var currentVlaue: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.headline)
            
            ParsedText(stock)
                .contentTransition(.numericText())
                .padding()
            
            Text("Current value: \(currentVlaue)")
        }
        .foregroundColor(.white)
        .animation(.smooth, value: stock)
        .padding()
        .background(Color.blue)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
    }
}

extension View {
    func ParsedText(_ text: String) -> Text {
        // Split the text by `**`
        let parts = text.components(separatedBy: "**")
        var result: Text = Text("")
        
        // Iterate through parts and apply bold or regular styles
        for (index, part) in parts.enumerated() {
            if index % 2 == 0 {
                // Regular text
                result = result + Text(part).fontWeight(.light)
            } else {
                // Bold text
                result = result + Text(part).fontWeight(.bold)
            }
        }
        
        return result
    }
}

#Preview {
    LiveUpdatesView()
}
