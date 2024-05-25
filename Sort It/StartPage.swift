//
//  StartPage.swift
//  Sort It
//
//  Created by Calista Kalleya on 18/05/24.
//


import SwiftUI

struct StartPage: View {
    @Binding var currentPage: Page
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var isPressed = false
    
    var body: some View {
        ZStack {
            Image("Background1")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Button(action: {
//                    audioPlayerManager.playSound(named: "cardflip")
//                    currentPage = .game
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = true
                    }
                    audioPlayerManager.playSound(named: "cardflip")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        withAnimation(.easeInOut(duration: 0.1)) {
                            isPressed = false
                        }
                        currentPage = .countdown
                    }
                }) {
                    Image("StartButton") // Replace "StartButtonImage" with the actual name of your image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300) // Adjust the size as needed
                        .padding(.bottom, 240)
                }
                .padding()
            }
        }
    }
}
struct StartPage_Previews: PreviewProvider {
    static var previews: some View {
        StartPage(currentPage: .constant(.start))
    }
}
