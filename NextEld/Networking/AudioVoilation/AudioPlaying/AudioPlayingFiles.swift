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
    let synthesizer = AVSpeechSynthesizer()
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
    
    

    func speak(text: String, languageCode: String = Locale.current.identifier) {
        // 3. Create an utterance
        let utterance = AVSpeechUtterance(string: "ਸਤਿ ਸ੍ਰੀ ਅਕਾਲ, ਮੈਂ ਪੰਜਾਬੀ ਵਿੱਚ ਬੋਲ ਰਿਹਾ ਹਾਂ।")
        let voice = AVSpeechSynthesisVoice.speechVoices().first { voice in
            voice.gender == .male && voice.language == "pa-IN"
        }
       
        // Optionally configure parameters
        utterance.voice = voice
        utterance.rate = 0.5 // Adjust speaking rate (0.0 to 1.0)
        utterance.pitchMultiplier = 1.0 // Adjust pitch (0.5 to 2.0)
        // 4. Speak the utterance
        synthesizer.speak(utterance)
    }
}
