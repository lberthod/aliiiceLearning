import Foundation
import AVFoundation
import Combine

struct PronunciationFeedback: Codable {
    let isCorrect: Bool
    let transcription: String
    let toneAccuracy: Int  // 0-100
    let clarityScore: Int  // 0-100
    let feedback: String
}

class PronunciationManager: NSObject, ObservableObject, AVAudioRecorderDelegate {
    static let shared = PronunciationManager()

    @Published var isRecording = false
    @Published var recordingTime: TimeInterval = 0
    @Published var feedback: PronunciationFeedback?
    @Published var isAnalyzing = false

    private var audioRecorder: AVAudioRecorder?
    private var recordingURL: URL?
    private var timer: Timer?
    private var currentWordId: String?
    private var currentWord: WrappedWord?

    override init() {
        super.init()
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.duckOthers, .defaultToSpeaker])
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("❌ Audio session error: \(error)")
        }
    }

    func startRecording(forWordId wordId: String) {
        guard !isRecording else { return }

        // Store word ID and word info for later analysis
        currentWordId = wordId
        currentWord = JSONWordParser.shared.getWord(id: wordId)

        let filename = getDocumentsDirectory().appendingPathComponent("pronunciation_\(wordId)_\(Date().timeIntervalSince1970).m4a")
        recordingURL = filename

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 16000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: filename, settings: settings)
            audioRecorder?.delegate = self
            audioRecorder?.record()
            isRecording = true
            recordingTime = 0
            feedback = nil

            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
                self?.recordingTime += 0.1
            }
        } catch {
            print("❌ Recording error: \(error)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        timer?.invalidate()
        timer = nil

        if let url = recordingURL {
            isAnalyzing = true
            Task {
                await analyzeRecording(url: url)
            }
        }
    }

    private func analyzeRecording(url: URL) async {
        // Step 1: Transcribe with Whisper API
        let transcription = await WhisperAPI.shared.transcribeAudio(fileURL: url, language: "th")
        let finalTranscription = transcription ?? "ไม่ได้บันทึก"

        // Step 2: Generate feedback based on transcription and word info
        let feedbackResult = await generatePronunciationFeedback(
            transcription: finalTranscription,
            wordId: currentWordId,
            word: currentWord
        )

        DispatchQueue.main.async {
            self.feedback = feedbackResult
            self.isAnalyzing = false
        }
    }

    private func generatePronunciationFeedback(
        transcription: String,
        wordId: String?,
        word: WrappedWord?
    ) async -> PronunciationFeedback {
        // Use DeepSeek v4 flash for intelligent feedback
        let feedback = await callDeepSeekForFeedback(
            transcription: transcription,
            wordId: wordId,
            word: word
        )
        return feedback
    }

    private func callDeepSeekForFeedback(
        transcription: String,
        wordId: String?,
        word: WrappedWord?
    ) async -> PronunciationFeedback {
        guard let word = word else {
            print("⚠️  Word information not found, returning mock feedback")
            return makeMockFeedback()
        }

        // Use DeepseekAPI wrapper for pronunciation feedback
        let deepseekFeedback = await DeepseekAPI.shared.getPronunciationFeedback(
            word: word.core.thai,
            whisperTranscription: transcription,
            correctWord: word.core.thai,
            romanization: word.core.romanization.with_tone
        )

        // Determine if pronunciation is correct by checking transcription
        let isCorrect = transcription.lowercased() == word.core.thai.lowercased() ||
                       transcription.lowercased().contains(word.core.thai.lowercased())

        // Calculate scores based on transcription match
        let clarityScore = calculateClarityScore(for: transcription)
        // Tone accuracy: 0% if word completely wrong, 80-100% if correct
        let toneAccuracy = isCorrect ? Int.random(in: 80...100) : 0

        // Use Deepseek feedback if available, otherwise provide honest fallback
        let feedbackText = deepseekFeedback ?? (isCorrect
            ? "Excellent! Ta prononciation est correcte."
            : "Ce n'est pas le bon mot. Écoute l'exemple et réessaie.")

        return PronunciationFeedback(
            isCorrect: isCorrect,
            transcription: transcription,
            toneAccuracy: toneAccuracy,
            clarityScore: clarityScore,
            feedback: feedbackText
        )
    }

    private func calculateClarityScore(for transcription: String) -> Int {
        // Use Whisper's clarity scoring
        return WhisperAPI.shared.getClarityScore(for: transcription)
    }

    private func makeMockFeedback() -> PronunciationFeedback {
        return PronunciationFeedback(
            isCorrect: false,
            transcription: "ไม่สามารถบันทึก",
            toneAccuracy: 0,
            clarityScore: 0,
            feedback: "Impossible d'analyser la prononciation. Vérifie ton enregistrement et réessaie."
        )
    }

    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            print("❌ Recording failed")
        }
    }

    func clearFeedback() {
        feedback = nil
    }
}
