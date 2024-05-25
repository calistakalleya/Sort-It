//
//  ReplayPage.swift
//  Sort It
//
//  Created by Calista Kalleya on 18/05/24.
//

//import SwiftUI
//
//struct ReplayPage: View {
//    @Binding var currentPage: Page
//    @StateObject private var audioPlayerManager = AudioPlayerManager()
//
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            Button(action: {
//                audioPlayerManager.playSound(named: "cardflip")
//                currentPage = .start
//            }) {
//                Image("Replay")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 350, height: 290)
//                    .cornerRadius(16)
//                    .padding(.bottom, 190)
//            }
//            .padding(.bottom, 5)
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(
//            Image("Background3")
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .edgesIgnoringSafeArea(.all)
//        )
//    }
//}
//
//struct ReplayPage_Previews: PreviewProvider {
//    static var previews: some View {
//        ReplayPage(currentPage: .constant(.replay))
//    }
//}

import SwiftUI

struct ReplayPage: View {
    @Binding var currentPage: Page
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @State private var isPressed = false
    
    var body: some View {
        VStack {
            Spacer()
            
            Button(action: {
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
                    .scaleEffect(isPressed ? 0.9 : 1.0) // Perubahan skala untuk animasi
            }
            .padding(.bottom, 5)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            Image("Background3")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct ReplayPage_Previews: PreviewProvider {
    static var previews: some View {
        ReplayPage(currentPage: .constant(.replay))
    }
}
