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
        // Step 1: Generate mock feedback (Whisper integration deferred to Phase 2)
        // In production, this would call Whisper API for transcription
        let mockTranscription = generateMockTranscription()

        // Step 2: Generate feedback based on transcription
        let feedbackResult = await generatePronunciationFeedback(
            transcription: mockTranscription
        )

        DispatchQueue.main.async {
            self.feedback = feedbackResult
            self.isAnalyzing = false
        }
    }

    private func generateMockTranscription() -> String {
        // TODO: Replace with actual Whisper API call in Phase 2
        return "แมว"  // Mock transcription
    }

    private func generatePronunciationFeedback(transcription: String) async -> PronunciationFeedback {
        // Use DeepSeek v4 flash for intelligent feedback
        let feedback = await callDeepSeekForFeedback(transcription: transcription)
        return feedback
    }

    private func callDeepSeekForFeedback(transcription: String) async -> PronunciationFeedback {
        let apiKey = ProcessInfo.processInfo.environment["DEEPSEEK_API_KEY"] ?? ""

        guard !apiKey.isEmpty else {
            print("⚠️  DEEPSEEK_API_KEY not found, returning mock feedback")
            return makeMockFeedback()
        }

        let prompt = """
        You are a Thai language pronunciation expert. Analyze this pronunciation attempt:

        Transcription: \(transcription)

        Provide feedback in French in this exact JSON format:
        {
          "isCorrect": boolean,
          "toneAccuracy": 0-100 (how accurate is the tone?),
          "clarityScore": 0-100 (how clear is the pronunciation?),
          "feedback": "1-2 sentence feedback in French (max 50 words)"
        }

        Only return valid JSON, no markdown.
        """

        var request = URLRequest(url: URL(string: "https://api.deepseek.com/chat/completions")!)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = [
            "model": "deepseek-chat",
            "messages": [
                ["role": "user", "content": prompt]
            ],
            "temperature": 0.7,
            "max_tokens": 200
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            return makeMockFeedback()
        }

        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ DeepSeek API error")
                return makeMockFeedback()
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {

                // Parse JSON response
                if let feedbackData = content.data(using: .utf8),
                   let feedbackDict = try JSONSerialization.jsonObject(with: feedbackData) as? [String: Any] {

                    let isCorrect = feedbackDict["isCorrect"] as? Bool ?? true
                    let toneAccuracy = feedbackDict["toneAccuracy"] as? Int ?? 80
                    let clarityScore = feedbackDict["clarityScore"] as? Int ?? 80
                    let feedbackText = feedbackDict["feedback"] as? String ?? "Bonne tentative!"

                    return PronunciationFeedback(
                        isCorrect: isCorrect,
                        transcription: transcription,
                        toneAccuracy: toneAccuracy,
                        clarityScore: clarityScore,
                        feedback: feedbackText
                    )
                }
            }
        } catch {
            print("❌ DeepSeek request error: \(error)")
        }

        return makeMockFeedback()
    }

    private func makeMockFeedback() -> PronunciationFeedback {
        return PronunciationFeedback(
            isCorrect: true,
            transcription: "แมว",
            toneAccuracy: Int.random(in: 70...95),
            clarityScore: Int.random(in: 75...95),
            feedback: "Bonne prononciation! La clarté est excellente."
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
