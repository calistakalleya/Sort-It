//
//  CountdownView.swift
//  Sort It
//
//  Created by Calista Kalleya on 25/05/24.
//

import SwiftUI

struct CountdownView: View {
    @Binding var currentPage: Page
    @State private var countdown = 3
    @State private var showFinalMessage = false
    
    var body: some View {
        ZStack {
            Image("Background5")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer().frame(height: 500)
                
                Text(countdownText)
                    .font(countdownFont)
                    .font(Font.custom("Playground", size: 40))
                    .foregroundColor(Color(hex: "#C90958"))
                    .transition(.opacity)
                    .id(countdown)
                
                Spacer()
            }
        }
        .onAppear {
            startCountdown()
        }
    }
    
    private var countdownText: String {
        switch countdown {
        case 3, 2, 1:
            return "\(countdown)"
        case 0:
            return "Listen and Remember Carefully!"
        default:
            return ""
        }
    }
    private var countdownFont: Font {
        switch countdown {
        case 3, 2, 1:
            return Font.custom("Playground", size: 100) // Ukuran font besar untuk hitungan mundur
        case 0:
            return Font.custom("Playground", size: 45) // Ukuran font lebih kecil untuk pesan
        default:
            return Font.custom("Playground", size: 80)
        }
    }
    private func startCountdown() {
        for i in 0...3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i)) {
                self.countdown = 3 - i
                if self.countdown == 0 {
                    self.showFinalMessage = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.currentPage = .game
                    }
                }
            }
        }
    }
}
struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(currentPage: .constant(.countdown))
    }
}

