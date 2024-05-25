//
//  AudioPlayerManager.swift
//  Sort It
//
//  Created by Calista Kalleya on 24/05/24.
//

import AVFoundation
import Combine

class AudioPlayerManager: ObservableObject {
    private var audioPlayer: AVAudioPlayer?

    func playSound(named soundName: String, volume: Float = 1.0) {
        guard let soundURL = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("Sound file \(soundName).wav not found")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.volume = volume
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("Playing sound: \(soundName)")
        } catch {
            print("Error playing sound: \(error.localizedDescription)")
        }
    }
}

