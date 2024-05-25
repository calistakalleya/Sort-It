//
//  SongBack.swift
//  Sort It
//
//  Created by Calista Kalleya on 25/05/24.
//

import AVFoundation
import SwiftUI

class SongBack: ObservableObject {
    static let shared = SongBack()
    private var audioPlayer: AVAudioPlayer?

    private init() {
        // Configure the audio session to allow background audio playback
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers])
    }

    func playBacksound(named soundName: String) {
        if let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.numberOfLoops = -1 // Loop indefinitely
                audioPlayer?.volume = 1.0 // atur volume
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error.localizedDescription)")
            }
        }
    }
    func setVolume(_ volume: Float) {
            audioPlayer?.volume = volume
        }
    func stopBacksound() {
        audioPlayer?.stop()
    }
}

