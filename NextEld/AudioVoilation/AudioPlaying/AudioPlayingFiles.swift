//
//  AudioPlayingFiles.swift
//  NextEld
//
//  Created by Inurum   on 02/01/26.
//

import Foundation
import AVFoundation

final class AudioWarningManager {

    static let shared = AudioWarningManager()
    private var player: AVAudioPlayer?

    private init() {}

    func playWarningAudio(fileName: String) {
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "m4a") else {
            print("&^^^^^^^^^^^&^^^^^^^^^ Audio file not found:", fileName)
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("&^^^^^^^^^^^&^^^^^^^^^ Audio play error:", error.localizedDescription)
        }
    }

    func stopAudio() {
        player?.stop()
        player = nil
    }
}
