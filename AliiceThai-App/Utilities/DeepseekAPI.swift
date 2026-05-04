import Foundation

class DeepseekAPI {
    static let shared = DeepseekAPI()

    private let apiKey: String
    private let baseURL = "https://api.deepseek.com/chat/completions"
    private let model = "deepseek-chat"  // Deepseek v4 Flash

    init() {
        // Get API key from environment, .plist, or Build Settings
        self.apiKey = ProcessInfo.processInfo.environment["DEEPSEEK_API_KEY"]
            ?? Bundle.main.infoDictionary?["DEEPSEEK_API_KEY"] as? String
            ?? ""
    }

    // MARK: - Quiz Feedback (Wrong Answer Explanation)

    func getWrongAnswerFeedback(
        question: String,
        userAnswer: String,
        correctAnswer: String,
        context: String = ""
    ) async -> String? {
        let prompt = """
        L'utilisateur apprend le thaï. Il a donné une mauvaise réponse à une question de quiz.

        Question: \(question)
        Réponse de l'utilisateur: \(userAnswer)
        Bonne réponse: \(correctAnswer)
        \(context.isEmpty ? "" : "Contexte: \(context)")

        Fournis une explication courte et claire (1-2 phrases) de pourquoi sa réponse était incorrecte et aide-le à comprendre la bonne réponse. Réponds en français.
        """

        return await callDeepseek(prompt: prompt, maxTokens: 150)
    }

    // MARK: - Tone Feedback

    func getToneErrorFeedback(
        word: String,
        userSelectedTone: String,
        correctTone: String,
        romanization: String
    ) async -> String? {
        let prompt = """
        L'utilisateur apprend les tons du thaï. Il a identifié un mauvais ton.

        Mot: \(word) (\(romanization))
        Ton sélectionné par l'utilisateur: \(userSelectedTone)
        Bon ton: \(correctTone)

        Explique brièvement (1-2 phrases) la différence entre ces deux tons et comment les distinguer. Réponds en français.
        """

        return await callDeepseek(prompt: prompt, maxTokens: 150)
    }

    // MARK: - Confusable Pairs Feedback

    func getConfusablePairFeedback(
        word1: String,
        word2: String,
        translation1: String,
        translation2: String
    ) async -> String? {
        let prompt = """
        L'utilisateur a confondu deux mots thaïs similaires.

        Mot 1: \(word1) = \(translation1)
        Mot 2: \(word2) = \(translation2)

        Explique brièvement (2-3 phrases) la différence clé entre ces deux mots pour aider l'utilisateur à ne plus les confondre. Réponds en français.
        """

        return await callDeepseek(prompt: prompt, maxTokens: 200)
    }

    // MARK: - Pronunciation Feedback

    func getPronunciationFeedback(
        word: String,
        whisperTranscription: String,
        correctWord: String,
        romanization: String
    ) async -> String? {
        let prompt = """
        L'utilisateur a enregistré sa prononciation d'un mot thaï.

        Mot cible: \(correctWord) (\(romanization))
        Transcription Whisper de sa prononciation: \(whisperTranscription)

        Si la transcription Whisper correspond au mot (ou est très proche), félicite l'utilisateur brièvement.
        Si la transcription est différente, suggère comment il peut améliorer sa prononciation en 1-2 phrases courtes.
        Réponds en français.
        """

        return await callDeepseek(prompt: prompt, maxTokens: 150)
    }

    // MARK: - Generic Deepseek Call

    private func callDeepseek(
        prompt: String,
        maxTokens: Int = 200,
        temperature: Double = 0.7
    ) async -> String? {
        guard !apiKey.isEmpty else {
            print("❌ Deepseek API key not configured")
            return nil
        }

        let requestBody: [String: Any] = [
            "model": model,
            "messages": [
                [
                    "role": "user",
                    "content": prompt
                ]
            ],
            "max_tokens": maxTokens,
            "temperature": temperature
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            print("❌ Failed to serialize request")
            return nil
        }

        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                return nil
            }

            guard httpResponse.statusCode == 200 else {
                print("❌ Deepseek API error: \(httpResponse.statusCode)")
                if let errorStr = String(data: data, encoding: .utf8) {
                    print("Response: \(errorStr)")
                }
                return nil
            }

            if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
               let choices = json["choices"] as? [[String: Any]],
               let firstChoice = choices.first,
               let message = firstChoice["message"] as? [String: Any],
               let content = message["content"] as? String {
                return content.trimmingCharacters(in: .whitespacesAndNewlines)
            }

            return nil
        } catch {
            print("❌ Deepseek API call failed: \(error.localizedDescription)")
            return nil
        }
    }
}

// MARK: - Response Models

struct DeepseekResponse: Codable {
    let choices: [Choice]

    struct Choice: Codable {
        let message: Message

        struct Message: Codable {
            let content: String
        }
    }
}
