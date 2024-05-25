//
//  SuccessPage.swift
//  Sort It
//
//  Created by Calista Kalleya on 21/05/24.
//

import SwiftUI

struct SuccessPage: View {
    @Binding var currentPage: Page
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Button(action: {
//                audioPlayerManager.playSound(named: "cardflip")
//                currentPage = .start
                withAnimation(.easeInOut(duration: 0.1)) {
                    isPressed = true
                }
                audioPlayerManager.playSound(named: "cardflip")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.easeInOut(duration: 0.1)) {
                        isPressed = false
                    }
                    currentPage = .start
                }
            }) {
                Image("Replay")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350, height: 290)
                    .cornerRadius(16)
                    .padding(.bottom, 190)
            }
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("Background4")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct SuccessPage_Previews: PreviewProvider {
    static var previews: some View {
        SuccessPage(currentPage: .constant(.success))
    }
}
