import SwiftUI

enum OutputTaskType {
    case shadowing       // Listen & repeat
    case cloze           // Fill blank with word
    case transcription   // Hear Thai, write Thai
    case translation     // FR→TH production

    var displayName: String {
        switch self {
        case .shadowing: return "Shadowing"
        case .cloze: return "Fill the Blank"
        case .transcription: return "Transcription"
        case .translation: return "Translation"
        }
    }
}

struct OutputTasksView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    let word: WrappedWord
    @State var currentTaskType: OutputTaskType = .shadowing
    @State var taskIndex = 0
    @State var completedTasks = 0
    let totalTasks = 4

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.8, green: 0.6, blue: 0.4),
                    Color(red: 0.7, green: 0.5, blue: 0.3)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Header
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                            .foregroundColor(.white)
                    }

                    VStack(spacing: 1) {
                        Text(localization.localize("output.tasks.title"))
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)

                        Text("\(completedTasks)/\(totalTasks) \(localization.localize("output.tasks.completed"))")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    NavigationLink(destination: EmptyView()) {
                        Image(systemName: "house.fill")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color.black.opacity(0.08))

                ScrollView {
                    VStack(spacing: 20) {
                        // Progress bar
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(currentTaskType.displayName)
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Spacer()

                                Text("\(taskIndex + 1)/\(totalTasks)")
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }

                            ProgressView(value: Double(taskIndex), total: Double(totalTasks))
                                .progressViewStyle(LinearProgressViewStyle(tint: Color(red: 1.0, green: 0.75, blue: 0.3)))
                        }
                        .padding(16)
                        .background(Color.black.opacity(0.12))
                        .cornerRadius(12)

                        // Task content
                        Group {
                            switch currentTaskType {
                            case .shadowing:
                                ShadowingTaskView(word: word)
                            case .cloze:
                                ClozeTaskView(word: word, onComplete: {
                                    nextTask()
                                })
                            case .transcription:
                                TranscriptionTaskView(word: word, onComplete: {
                                    nextTask()
                                })
                            case .translation:
                                TranslationTaskView(word: word, onComplete: {
                                    nextTask()
                                })
                            }
                        }

                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 20)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    func nextTask() {
        completedTasks += 1
        taskIndex += 1

        if taskIndex >= totalTasks {
            // All tasks complete
            gameState.recordOutputPractice(wordId: word.id)
            dismiss()
        } else {
            // Move to next task type
            let types: [OutputTaskType] = [.shadowing, .cloze, .transcription, .translation]
            if taskIndex < types.count {
                currentTaskType = types[taskIndex]
            }
        }
    }
}

// MARK: - Shadowing Task

struct ShadowingTaskView: View {
    let word: WrappedWord
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var pronManager = PronunciationManager.shared
    @ObservedObject var localization = LocalizationManager.shared

    var body: some View {
        VStack(spacing: 20) {
            Text(localization.localize("output.shadowing.title"))
                .font(.headline)
                .foregroundColor(.white)

            Text(localization.localize("output.shadowing.instruction"))
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))

            // Model audio
            VStack(spacing: 15) {
                Text(word.core.thai)
                    .font(.system(size: 48, weight: .bold))
                    .foregroundColor(.white)

                Text(word.core.romanization.with_tone)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.7))

                Button {
                    audioManager.playWord(thaiWord: word.core.thai)
                } label: {
                    Image(systemName: "speaker.wave.3.fill")
                        .font(.system(size: 40))
                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                }
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(12)

            // Record button
            VStack(spacing: 12) {
                if !pronManager.isRecording {
                    Button {
                        pronManager.startRecording(forWordId: word.id)
                    } label: {
                        Label(localization.localize("output.shadowing.record_button"), systemImage: "mic.fill")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                            .foregroundColor(.black)
                            .cornerRadius(8)
                    }
                } else {
                    HStack {
                        Image(systemName: "record.circle.fill")
                            .foregroundColor(.red)
                            .animation(.easeInOut(duration: 0.5), value: pronManager.isRecording)

                        Text("\(localization.localize("output.shadowing.recording")): \(String(format: "%.1f", pronManager.recordingTime))s")
                            .foregroundColor(.white)

                        Spacer()

                        Button(localization.localize("output.shadowing.stop_button")) {
                            pronManager.stopRecording()
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.white)
                    }
                    .padding()
                    .background(Color.red.opacity(0.1))
                    .cornerRadius(8)
                }

                if let feedback = pronManager.feedback {
                    FeedbackCard(feedback: feedback)
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.08))
        .cornerRadius(12)
    }
}

struct FeedbackCard: View {
    let feedback: PronunciationFeedback

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: feedback.isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(feedback.isCorrect ? .green : .orange)

                Text(feedback.isCorrect ? "Good attempt!" : "Try again")
                    .font(.headline)
                    .foregroundColor(.white)
            }

            HStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Tone Accuracy")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                    HStack(spacing: 5) {
                        ProgressView(value: Double(feedback.toneAccuracy) / 100)
                            .frame(width: 60)

                        Text("\(feedback.toneAccuracy)%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }

                VStack(alignment: .leading, spacing: 5) {
                    Text("Clarity")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.7))

                    HStack(spacing: 5) {
                        ProgressView(value: Double(feedback.clarityScore) / 100)
                            .frame(width: 60)

                        Text("\(feedback.clarityScore)%")
                            .font(.caption)
                            .foregroundColor(.white)
                    }
                }

                Spacer()
            }

            Text(feedback.feedback)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .padding()
        .background(Color.white.opacity(0.1))
        .cornerRadius(8)
    }
}

// MARK: - Cloze Task

struct ClozeTaskView: View {
    let word: WrappedWord
    @ObservedObject var localization = LocalizationManager.shared
    @State var userInput = ""
    @State var showFeedback = false
    @State var isCorrect = false
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(localization.localize("output.cloze.title"))
                .font(.headline)
                .foregroundColor(.white)

            // Sample sentence with blank
            let example = word.usage.example_sentences.first?.thai ?? "ฉันชอบ ___"
            let sentenceWithBlank = example.replacingOccurrences(of: word.core.thai, with: "___")

            VStack(spacing: 10) {
                HStack {
                    Text(sentenceWithBlank)
                        .font(.body)
                        .foregroundColor(.white)

                    Spacer()
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(8)
            }

            // Input field
            TextField(localization.localize("output.cloze.placeholder"), text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .foregroundColor(.black)

            // Check button
            if !showFeedback {
                Button(localization.localize("output.cloze.check_button")) {
                    checkAnswer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                .foregroundColor(.black)
                .cornerRadius(8)
                .fontWeight(.semibold)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? .green : .red)

                        Text(isCorrect ? "Correct! ✅" : "Try again ❌")
                            .font(.body)
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding()
                    .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)

                    if isCorrect {
                        Button(localization.localize("output.cloze.next_button")) {
                            onComplete()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.08))
        .cornerRadius(12)
    }

    func checkAnswer() {
        isCorrect = userInput.trimmingCharacters(in: .whitespaces) == word.core.thai
        showFeedback = true
    }
}

// MARK: - Transcription Task

struct TranscriptionTaskView: View {
    let word: WrappedWord
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    @State var userInput = ""
    @State var showFeedback = false
    @State var isCorrect = false
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(localization.localize("output.transcription.title"))
                .font(.headline)
                .foregroundColor(.white)

            Text(localization.localize("output.transcription.instruction"))
                .font(.caption)
                .foregroundColor(.white.opacity(0.85))

            // Play button
            Button {
                audioManager.playWord(thaiWord: word.core.thai)
            } label: {
                Image(systemName: "speaker.wave.3.fill")
                    .font(.system(size: 40))
                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)

            // Thai input
            TextField(localization.localize("output.transcription.placeholder"), text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .foregroundColor(.black)

            // Check button
            if !showFeedback {
                Button(localization.localize("output.transcription.check_button")) {
                    checkAnswer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                .foregroundColor(.black)
                .cornerRadius(8)
                .fontWeight(.semibold)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? .green : .red)

                        Text(isCorrect ? "Correct! ✅" : "Try again ❌")
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding()
                    .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)

                    if isCorrect {
                        Button(localization.localize("output.transcription.next_button")) {
                            onComplete()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.08))
        .cornerRadius(12)
    }

    func checkAnswer() {
        isCorrect = userInput == word.core.thai
        showFeedback = true
    }
}

// MARK: - Translation Task

struct TranslationTaskView: View {
    let word: WrappedWord
    @ObservedObject var localization = LocalizationManager.shared
    @State var userInput = ""
    @State var showFeedback = false
    @State var isCorrect = false
    let onComplete: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text(localization.localize("output.translation.title"))
                .font(.headline)
                .foregroundColor(.white)

            // French display
            HStack {
                Text("🇫🇷")
                    .font(.system(size: 40))

                VStack(alignment: .leading, spacing: 4) {
                    Text(word.core.translation.fr)
                        .font(.headline)
                        .foregroundColor(.white)

                    if let en = word.core.translation.en as? String {
                        Text("(\(en))")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.7))
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)

            // Input
            TextField(localization.localize("output.translation.placeholder"), text: $userInput)
                .textFieldStyle(.roundedBorder)
                .autocorrectionDisabled()
                .foregroundColor(.black)

            // Check button
            if !showFeedback {
                Button(localization.localize("output.translation.check_button")) {
                    checkAnswer()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                .foregroundColor(.black)
                .cornerRadius(8)
                .fontWeight(.semibold)
            } else {
                VStack(spacing: 12) {
                    HStack {
                        Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isCorrect ? .green : .red)

                        Text(isCorrect ? "Correct! ✅" : "Try again ❌")
                            .foregroundColor(.white)

                        Spacer()
                    }
                    .padding()
                    .background(isCorrect ? Color.green.opacity(0.1) : Color.red.opacity(0.1))
                    .cornerRadius(8)

                    if isCorrect {
                        Button(localization.localize("output.translation.next_button")) {
                            onComplete()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .fontWeight(.semibold)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.black.opacity(0.08))
        .cornerRadius(12)
    }

    func checkAnswer() {
        isCorrect = userInput == word.core.thai
        showFeedback = true
    }
}

#Preview {
    Text("Preview not available")
}
