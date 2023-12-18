//
//  MusicPlayer.swift
//  NC2_AvocadoTeam
//
//  Created by Isabella Di Lorenzi on 14/12/23.
//

import AVFoundation
import SpriteKit

var audioPlayer: AVAudioPlayer?
var backgroundMusicPlayer: AVAudioPlayer?

func playSound(sound: String, type: String){
    if let path = Bundle.main.path(forResource: sound, ofType: type) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            audioPlayer?.play()
        } catch {
            print("ERROR: Could not find sound file")
        }
    }
}

/*
func stopSound() {
    if let player = audioPlayer {
        if player.isPlaying {
            player.stop()
        }
    }
} */
