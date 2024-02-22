//
//  BGMManager.swift
//  BubbleShot
//
//  Created by unboxers on 2/21/24.
//

import Foundation
import AVFoundation

class BGMManager {
    var audioPlayer: AVAudioPlayer?
    
    func playBGM() {
        let sound=Bundle.main.url(forResource: "bgm", withExtension: "mp3")
        
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
    
    func stop() {
        audioPlayer?.stop()
    }
}
