import Foundation

class WhisperAPI {
    static let shared = WhisperAPI()

    private let apiKey: String
    private let baseURL = "https://api.openai.com/v1/audio/transcriptions"

    init() {
        // Get API key from environment, .plist, or Build Settings
        self.apiKey = ProcessInfo.processInfo.environment["OPENAI_API_KEY"]
            ?? Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String
            ?? ""
    }

    // MARK: - Transcribe Audio

    func transcribeAudio(
        fileURL: URL,
        language: String = "th"  // Thai
    ) async -> String? {
        guard !apiKey.isEmpty else {
            print("❌ OpenAI API key not configured")
            return nil
        }

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("❌ Audio file not found: \(fileURL.path)")
            return nil
        }

        do {
            let audioData = try Data(contentsOf: fileURL)

            // Create multipart form data
            let boundary = UUID().uuidString
            var body = Data()

            // Add file
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"file\"; filename=\"audio.m4a\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: audio/mp4\r\n\r\n".data(using: .utf8)!)
            body.append(audioData)
            body.append("\r\n".data(using: .utf8)!)

            // Add model
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"model\"\r\n\r\n".data(using: .utf8)!)
            body.append("whisper-1\r\n".data(using: .utf8)!)

            // Add language
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"language\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(language)\r\n".data(using: .utf8)!)

            body.append("--\(boundary)--\r\n".data(using: .utf8)!)

            // Create request
            var request = URLRequest(url: URL(string: baseURL)!)
            request.httpMethod = "POST"
            request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            request.httpBody = body

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response from Whisper API")
                return nil
            }

            guard httpResponse.statusCode == 200 else {
                print("❌ Whisper API error: \(httpResponse.statusCode)")
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response: \(errorStr)")
                }
                return nil
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let text = json["text"] as? String {
                return text.trimmingCharacters(in: .whitespacesAndNewlines)
            }

            return nil
        } catch {
            print("❌ Whisper API call failed: \(error.localizedDescription)")
            return nil
        }
    }

    // MARK: - Get Clarity Score

    func getClarityScore(for transcription: String) -> Int {
        // Simple heuristic for clarity score
        // In production, could call Deepseek for this analysis

        let confidenceMetrics = [
            transcription.count >= 3,  // Minimum word length
            !transcription.contains(""),  // No empty transcription
            transcription.trimmingCharacters(in: .whitespaces).count > 0
        ]

        let score = confidenceMetrics.filter { $0 }.count * 33
        return min(score, 100)
    }
}

// MARK: - Response Models

struct WhisperResponse: Codable {
    let text: String
}
