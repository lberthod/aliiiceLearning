import SwiftUI

struct ShadowingView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var pronManager = PronunciationManager.shared
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.dismiss) var dismiss

    let word: WrappedWord
    let toneMarking: ToneMarking

    @State var showFeedback = false
    @State var attemptCount = 0
    let maxAttempts = 3

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
                ScrollView {
                    VStack(spacing: 20) {
                        // Model audio
                        VStack(spacing: 15) {
                            VStack(spacing: 12) {
                                Text(word.core.thai)
                                    .font(.system(size: 56, weight: .bold))
                                    .foregroundColor(.black)

                                HStack(spacing: 10) {
                                    Text(word.core.romanization.with_tone)
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                        .padding(8)
                                        .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                                        .cornerRadius(4)

                                    Text(toneMarking.toneVisual)
                                        .font(.system(size: 24))
                                        .foregroundColor(.black)
                                }

                                Text(word.core.translation.fr)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }

                            Button {
                                audioManager.playWord(thaiWord: word.core.thai)
                            } label: {
                                HStack {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.system(size: 20))

                                    Text("Listen (Model)")
                                        .font(.body)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 1.0, green: 0.6, blue: 0.2))
                                .cornerRadius(8)
                            }
                            .foregroundColor(.white)
                        }
                        .padding()
                        .background(Color(red: 0.95, green: 0.9, blue: 0.85))
                        .cornerRadius(8)

                        // Record section
                        VStack(spacing: 15) {
                            if !pronManager.isRecording {
                                Button {
                                    pronManager.clearFeedback()
                                    pronManager.startRecording(forWordId: word.id)
                                    attemptCount += 1
                                } label: {
                                    HStack {
                                        Image(systemName: "mic.fill")
                                            .font(.system(size: 18))

                                        Text(localization.localize("tone.shadowing.record"))
                                            .font(.body)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color(red: 0.8, green: 0.3, blue: 0.3))
                                    .cornerRadius(8)
                                }
                                .foregroundColor(.white)

                                if attemptCount > 0 {
                                    Text("\(localization.localize("tone.shadowing.attempt")) \(attemptCount)/\(maxAttempts)")
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                }
                            } else {
                                VStack(spacing: 10) {
                                    HStack {
                                        Image(systemName: "record.circle.fill")
                                            .foregroundColor(.red)
                                            .animation(.easeInOut(duration: 0.5), value: pronManager.isRecording)

                                        Text("\(localization.localize("tone.shadowing.recording")) \(String(format: "%.1f", pronManager.recordingTime))s")
                                            .font(.body)

                                        Spacer()

                                        Button(localization.localize("tone.shadowing.stop")) {
                                            pronManager.stopRecording()
                                        }
                                        .buttonStyle(.bordered)
                                    }
                                    .padding()
                                    .background(Color.red.opacity(0.1))
                                    .cornerRadius(8)
                                }
                            }

                            // Feedback display
                            if pronManager.isAnalyzing {
                                HStack {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                        .tint(.black)

                                    Text(localization.localize("tone.shadowing.analyzing"))
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .background(Color(red: 0.95, green: 0.9, blue: 0.85))
                                .cornerRadius(8)
                            } else if let feedback = pronManager.feedback {
                                FeedbackCardView(feedback: feedback)
                            }
                        }

                        // Next button
                        if let feedback = pronManager.feedback, !pronManager.isAnalyzing {
                            VStack(spacing: 12) {
                                if feedback.isCorrect || attemptCount >= maxAttempts {
                                    Button {
                                        gameState.recordToneAttempt(wordId: word.id, isCorrect: feedback.isCorrect)
                                        if feedback.isCorrect {
                                            gameState.addStar()
                                        }
                                        dismiss()
                                    } label: {
                                        HStack {
                                            Text(feedback.isCorrect ? localization.localize("tone.shadowing.excellent") : localization.localize("tone.shadowing.continue"))
                                                .font(.body)
                                                .fontWeight(.semibold)

                                            Spacer()

                                            Image(systemName: feedback.isCorrect ? "checkmark.circle.fill" : "chevron.right")
                                                .font(.system(size: 18))
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.green)
                                        .cornerRadius(8)
                                    }
                                    .foregroundColor(.white)
                                } else {
                                    Button {
                                        pronManager.clearFeedback()
                                    } label: {
                                        Text(localization.localize("tone.shadowing.try_again"))
                                            .font(.body)
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(Color(red: 0.2, green: 0.8, blue: 1.0))
                                            .cornerRadius(8)
                                    }
                                    .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle(localization.localize("tone.shadowing.title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct FeedbackCardView: View {
    @ObservedObject var localization = LocalizationManager.shared
    let feedback: PronunciationFeedback

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: feedback.isCorrect ? "checkmark.circle.fill" : "waveform.circle")
                    .font(.system(size: 20))
                    .foregroundColor(feedback.isCorrect ? .green : .orange)

                Text(feedback.isCorrect ? localization.localize("tone.feedback.excellent") : localization.localize("tone.feedback.complete"))
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                Spacer()
            }

            // Metrics
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(localization.localize("tone.feedback.tone_accuracy"))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        HStack(spacing: 8) {
                            ProgressView(value: Double(feedback.toneAccuracy) / 100)
                                .frame(width: 80)
                                .tint(Color(red: 1.0, green: 0.6, blue: 0.2))

                            Text("\(feedback.toneAccuracy)%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text(localization.localize("tone.feedback.clarity"))
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(.black)

                        HStack(spacing: 8) {
                            ProgressView(value: Double(feedback.clarityScore) / 100)
                                .frame(width: 80)
                                .tint(.green)

                            Text("\(feedback.clarityScore)%")
                                .font(.caption)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                        }
                    }
                }

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text(localization.localize("tone.feedback.feedback"))
                        .font(.caption2)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .textCase(.uppercase)

                    Text(feedback.feedback)
                        .font(.caption)
                        .lineLimit(3)
                        .foregroundColor(.black)
                }
            }
            .padding()
            .background(Color(red: 0.98, green: 0.95, blue: 0.90))
            .cornerRadius(6)
        }
        .padding()
        .background(Color(red: 0.95, green: 0.9, blue: 0.85))
        .cornerRadius(8)
    }
}

#Preview {
    NavigationStack {
        ShadowingView(
            word: WrappedWord(
                id: "cat",
                version: "1.0.0",
                status: "validated",
                core: CoreData(
                    emoji: "🐱",
                    thai: "แมว",
                    romanization: RomanizationData(simple: "maew", rtgs: "maew", with_tone: "mɛ̂ː"),
                    translation: TranslationData(fr: "chat", en: "cat")
                ),
                linguistic: LinguisticData(
                    word_type: "noun",
                    classifier: "ตัว",
                    syllables: [],
                    register: "neutral",
                    politeness: "neutral"
                ),
                audio: AudioData(tts_provider: "openai", voice: "thai_female_01", audio_key: "word_cat_th_normal", variants: AudioVariants(slow: "word_cat_slow", normal: "word_cat_normal", fast: "word_cat_fast")),
                learning: LearningData(level: "A1", priority: 1, frequency: "very_common", difficulty_score: 1, recommended_order: 1, skills: ["recognition"]),
                usage: UsageData(contexts: [], example_sentences: [], common_phrases: []),
                memory: MemoryData(mnemonic_fr: "", visual_strength: 0, emotional_tag: "", image_prompt: ""),
                relations: RelationsData(same_category: [], related_words: [], confusable_with: []),
                quiz: QuizData(enabled: true, question_types: [], distractors: []),
                user_progress_template: UserProgressTemplate(seen_count: 0, correct_count: 0, wrong_count: 0, mastery_score: 0, last_seen_at: nil, next_review_at: nil, ease_factor: 0, interval_days: 0, is_mastered: false),
                metadata: MetadataData(created_at: "", updated_at: "", source: "", notes: "")
            ),
            toneMarking: ToneMarking(
                wordId: "cat",
                thai: "แมว",
                romanizationRTGS: "maew",
                romanizationTone: "mɛ̂ː",
                toneNumber: 2,
                toneName: "falling",
                syllables: []
            )
        )
    }
}
