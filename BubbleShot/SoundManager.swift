//
//  SoundManager.swift
//  BubbleShot
//
//  Created by unboxers on 2/20/24.
//

import Foundation
import AVFoundation

class SoundManager {
    var audioPlayer: AVAudioPlayer?

    func playAudio(fileName: String) {
        
        let sound=Bundle.main.url(forResource: fileName, withExtension: "mp3")
        
        guard let url = sound else {
            print("Audio file not found")
            return
        }
        
        if FileManager.default.fileExists(atPath: url.path) {
            print("Audio file exists")
        } else {
            print("Audio file not found")
        }

         do {
//            let session = AVAudioSession.sharedInstance()
//            try! session.setCategory(AVAudioSession.Category.ambient)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            guard let audioPlayer = audioPlayer else {
                return
            }
        
            
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
            
            
            if audioPlayer.isPlaying {
                   print("sound playing")
               } else {
                   print("problem sound not playing")
                   
               }

        } catch {
            print("Error playing audio: \(error.localizedDescription)")
        }
    }
}
