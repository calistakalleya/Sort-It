//
//  ContentView.swift
//  Sort It
//
//  Created by Calista Kalleya on 18/05/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPage: Page = .start
    @StateObject private var songBack = SongBack.shared
    
    var body: some View {
        VStack {
//            if currentPage == .start {
//                StartPage(currentPage: $currentPage)
//            } else if currentPage == .countdown {
//                    CountdownView(currentPage: $currentPage)
//            } else if currentPage == .game {
//                GameView(currentPage: $currentPage)
//            } else if currentPage == .replay {
//                ReplayPage(currentPage: $currentPage)
//            } else if currentPage == .success {
//                SuccessPage(currentPage: $currentPage)
//            }
//        }
            switch currentPage {
            case .start:
                StartPage(currentPage: $currentPage)
            case .countdown:
                CountdownView(currentPage: $currentPage)
            case .game:
                GameView(currentPage: $currentPage)
            case .replay:
                ReplayPage(currentPage: $currentPage)
            case .success:
                SuccessPage(currentPage: $currentPage)
            }
        }
        .onAppear{
            songBack.playBacksound(named: "Backsound")
        }
        .onChange(of: currentPage) {
            if currentPage == .game {
                songBack.setVolume(0.1)
            } else {
                songBack.setVolume(1.0)
            }
        }
    }
}
enum Page {
    case start, countdown, game, replay, success
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
