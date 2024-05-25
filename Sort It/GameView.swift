//
//  GameView.swift
//  Sort It
//
//  Created by Calista Kalleya on 18/05/24.
//

import SwiftUI
import AVFoundation
import UniformTypeIdentifiers
import Combine

enum GameResult {
    case none, success, fail
}

struct GameView: View {
    @Binding var currentPage: Page
    @State private var fruits = ["Watermelon", "Melon", "Dragon Fruit", "Strawberry", "Grape", "Orange"]
    @State private var shuffledFruits: [String] = []
    @State private var userOrder = [String]()
    @State private var timeRemaining = 15
    @State private var isTimeUp = false
    @State private var gameResult: GameResult = .none
    @State private var movedFruits = Set<String>()
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlayingSound = false
    @State private var isBouncing = false
    
    @StateObject private var audioPlayerManager = AudioPlayerManager()
    @StateObject private var songBack = SongBack.shared
    
    @State private var timerCancellable: AnyCancellable?
    @State private var isSoundPlaying = true
    
    public init(currentPage: Binding<Page>) {
        self._currentPage = currentPage
    }
    
    var body: some View {
        ZStack{
            Image("Background2")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            VStack {
                Spacer().frame(height: 60)
                
                Text("Time Remaining: \(timeRemaining)")
                    .font(Font.custom("Playground", size: 25))
                    .foregroundColor(Color(hex: "#87A505"))
                
                Spacer().frame(height: 60)
                
                if isPlayingSound {
                    Image (systemName: "speaker.wave.3.fill")
                        .scaleEffect(5)
                        .foregroundColor(.orange)
                        .offset(y: isBouncing ? -10 : 0) // Bounce effect
                        .animation(
                            Animation.easeInOut(duration: 0.5)
                                .repeatForever(autoreverses: true), value: isBouncing
                        )
                        .onAppear {
                            isBouncing = true
                        }
                        .onDisappear {
                            isBouncing = false
                        }
                        .padding(100)
                }
                
                Spacer ()
            
                VStack{
                    HStack {
                        ForEach(fruits, id: \.self) { fruit in
                            Image(fruit)
                                .resizable()
                                .frame(width: 141, height: 214)
                                .cornerRadius(8)
                                .opacity(movedFruits.contains(fruit) ? 0.5 : 1.0)
                                .onDrag {
                                    NSItemProvider(object: fruit as NSString)
                            }
                                .disabled(isSoundPlaying)
                        }
                    }
                    .padding(.bottom, 75)
                    
                    HStack {
                        ForEach(userOrder, id: \.self) { order in
                            Image(order)
                                .resizable()
                                .frame(width: 141, height: 214)
                                .cornerRadius(8)
                        }
                        .onDrop(of: [UTType.text], delegate: FruitDropDelegate(currentOrder: $userOrder, movedFruits: $movedFruits, fruits: shuffledFruits, checkOrder: checkOrder, audioPlayerManager: audioPlayerManager, isSoundPlaying: $isSoundPlaying))
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.yellow.opacity(0.3)) // Background color for user ordered cards
                            .frame(height: 234) // Adjust height to match card height
                            .padding(.horizontal, 10)
                    )
                    .padding(.vertical, 20)
                }
                Spacer()
            }
            .task {
                startGame()
            }
            .onChange(of: timeRemaining) {
                if timeRemaining <= 0 {
                    isTimeUp = true
                    evaluateGameResult()
                }
            }
            .onAppear {
                songBack.setVolume(0.0)
            }
            .onDisappear {
                songBack.setVolume(1.0)
            }
        }
    }
    
    private func startGame() {
        shuffledFruits = fruits.shuffled()
        userOrder = ["Arrow"]
        timeRemaining = 20
        isTimeUp = false
        gameResult = .none
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            playSoundSequence()
        }
    }
    private func playSoundSequence() {
        playNextSound(index: 0)
    }
    
    private func playNextSound(index: Int) {
        guard index < shuffledFruits.count else {
            self.isSoundPlaying = false
            self.startTimerAndEnableDragAndDrop()
            return
        }
        
        let fruit = shuffledFruits[index]
        
        if let url = Bundle.main.url(forResource: fruit, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.volume = 1.0
                audioPlayer?.prepareToPlay()
                audioPlayer?.play()
                isPlayingSound = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.isPlayingSound = false
                    self.playNextSound(index: index + 1)
                }
            } catch {
                print("Error playing sound for \(fruit): \(error.localizedDescription)")
                isPlayingSound = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                    self.playNextSound(index: index + 1)
                }
            }
        }
    }
    private func startTimerAndEnableDragAndDrop(){
        timerCancellable = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
            .sink { _ in
                if self.timeRemaining > 0 /*&& self.isGameStarted */{
                    print(timeRemaining)
                    self.timeRemaining -= 1
                    
                }
                if self.timeRemaining  == 0 {
                    self.isTimeUp = true
                }
                    }
    }
    private func checkOrder(){
        if userOrder.count - 1 == shuffledFruits.count {
            print(userOrder)
            print(shuffledFruits)
            if userOrder[0] == "Arrow" {
                userOrder.remove(at: 0)
            }
            
            if userOrder == shuffledFruits {
                gameResult = GameResult.success
            } else {
                gameResult = GameResult.fail
            }
            evaluateGameResult()
        }
    }
    
    private func evaluateGameResult() {
        if gameResult == .success {
            currentPage = .success
            
        } else {
            currentPage = .replay
        }
    }
}
    
    struct FruitDropDelegate: DropDelegate {
        @Binding var currentOrder: [String]
        @Binding var movedFruits: Set<String>
        let fruits: [String]
        let checkOrder: () -> Void
        let audioPlayerManager: AudioPlayerManager
        @Binding var isSoundPlaying: Bool
        
        func performDrop(info: DropInfo) -> Bool {
            guard !isSoundPlaying,
                    let item = info.itemProviders(for: [UTType.text]).first else { return false }
            item.loadItem(forTypeIdentifier: UTType.text.identifier, options: nil) { (data, error) in
                if let data = data as? Data, let fruit = String(data: data, encoding: .utf8), fruits.contains(fruit) {
                    DispatchQueue.main.async {
                        if !currentOrder.contains(fruit) {
                            currentOrder.append(fruit)
                            movedFruits.insert(fruit)
                            checkOrder()
                            audioPlayerManager.playSound(named: "cardflip")
                        }
                    }
                }
            }
            return true
        }
    }

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(currentPage: .constant(.game))
    }
}
