//
//  TesterView.swift
//  NanoChallenge2
//
//  Created by Arrick Russell Adinoto on 26/05/24.
//

import SwiftUI

struct TesterView: View {
    @State private var displayedText = ""
    let fullText = "Hello, SwiftUI!"
    
    var body: some View {
        Text(displayedText)
            .font(.system(size: 24))
            .foregroundColor(.black)
            .fontWeight(.medium)
            .onAppear {
                displayTextWithAnimation(text: fullText, interval: 1.0)
            }
    }
    
    func displayTextWithAnimation(text: String, interval: TimeInterval) {
        displayedText = ""
        var index = 0
        
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { timer in
            if index < text.count {
                let charIndex = text.index(text.startIndex, offsetBy: index)
                displayedText.append(text[charIndex])
                index += 1
            } else {
                timer.invalidate()
            }
        }
    }
}


#Preview{
    TesterView()
}
