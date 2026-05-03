import Foundation
import AVFoundation
import Combine

class AudioManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    static let shared = AudioManager()

    @Published var isMuted = false
    @Published var playbackSpeed: Float = 1.0
    private var audioPlayers: [AVAudioPlayer] = []
    private var currentAVPlayer: AVPlayer?
    private let speechSynthesizer = AVSpeechSynthesizer()

    override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playback, mode: .default, options: [.duckOthers])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("Failed to set up audio session: \(error)")
        }
    }

    func speakThai(_ text: String) {
        guard !isMuted else { return }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "th-TH") // Thai language
        utterance.rate = 0.5 // Slower for kids
        utterance.pitchMultiplier = 1.1 // Slightly higher pitch
        utterance.volume = 0.8

        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }

    func speakEnglish(_ text: String) {
        guard !isMuted else { return }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US") // English
        utterance.rate = 0.5 // Slower for kids
        utterance.pitchMultiplier = 1.1
        utterance.volume = 0.8

        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }

    func speakFrench(_ text: String) {
        guard !isMuted else { return }

        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "fr-FR") // French
        utterance.rate = 0.5 // Slower for kids
        utterance.pitchMultiplier = 1.1
        utterance.volume = 0.8

        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }

    func playSound(named soundName: String, ext: String = "mp3") {
        guard !isMuted else { return }

        if let url = Bundle.main.url(forResource: soundName, withExtension: ext) {
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.delegate = self
                player.play()
                audioPlayers.append(player)

                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) { [weak self] in
                    self?.audioPlayers.removeAll { $0 === player }
                }
            } catch {
                print("Failed to play sound \(soundName): \(error)")
            }
        }
    }

    func playCelebrationSound() {
        playSound(named: "celebration")
    }

    func playCorrectSound() {
        playSound(named: "correct")
    }

    func playWrongSound() {
        playSound(named: "wrong")
    }

    func playTapSound() {
        playSound(named: "tap")
    }

    func playCategorySelectSound() {
        playSound(named: "category-select")
    }

    // MARK: - Word-Specific Audio (Phase 1)

    func playWord(thaiWord: String, variant: String = "normal") {
        guard !isMuted else { return }
        // Use TTS to pronounce Thai word
        // Future: Load pre-recorded audio from assets
        speakThai(thaiWord)  // Pronounce the Thai word
    }

    func playToneVariant(word: String, tone: String) {
        guard !isMuted else { return }
        // Play word with emphasis on specific tone
        // Current: Use TTS with pitch adjustment
        // Future: Use pre-recorded tone variants

        let utterance = AVSpeechUtterance(string: word)
        utterance.voice = AVSpeechSynthesisVoice(language: "th-TH")
        utterance.rate = 0.5
        utterance.volume = 0.8

        // Adjust pitch based on tone
        switch tone.lowercased() {
        case "mid":
            utterance.pitchMultiplier = 1.0
        case "low":
            utterance.pitchMultiplier = 0.7
        case "falling":
            utterance.pitchMultiplier = 1.2
        case "rising":
            utterance.pitchMultiplier = 1.4
        case "high":
            utterance.pitchMultiplier = 1.6
        default:
            utterance.pitchMultiplier = 1.0
        }

        speechSynthesizer.stopSpeaking(at: .immediate)
        speechSynthesizer.speak(utterance)
    }

    func playPhrase(id: String) {
        guard !isMuted else { return }
        speakThai(id)
    }

    func setPlaybackSpeed(_ speed: Float) {
        playbackSpeed = speed
        if let player = currentAVPlayer {
            player.rate = speed
        }
    }
}
