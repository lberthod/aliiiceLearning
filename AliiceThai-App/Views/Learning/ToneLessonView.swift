import SwiftUI

struct ToneLessonView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    let toneMarking: ToneMarking
    let word: WrappedWord

    @State var isPlayingA = false
    @State var isPlayingB = false
    @State var selectedContrastTone: String?
    @State var showComparison = false

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
                    // Main word display
                    VStack(spacing: 12) {
                        Text(word.core.thai)
                            .font(.system(size: 56, weight: .bold))
                            .foregroundColor(.black)

                        HStack(spacing: 12) {
                            Text(word.core.romanization.with_tone)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                                .padding(8)
                                .background(Color(red: 1.0, green: 0.75, blue: 0.3))
                                .cornerRadius(4)

                            Text("\(localization.localize("tone.lesson.tone_label")) \(localization.localize("tone.name.\(toneMarking.toneName.lowercased())"))")
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(.black)
                        }

                        Text(word.core.translation.fr)
                            .font(.body)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(red: 0.95, green: 0.9, blue: 0.85))
                    .cornerRadius(8)

                    // Tone A (Current word tone)
                    VStack(spacing: 12) {
                        HStack {
                            Text("\(localization.localize("tone.lesson.tone1")) \(localization.localize("tone.name.\(toneMarking.toneName.lowercased())").uppercased())")
                                .font(.headline)
                                .fontWeight(.bold)
                                .foregroundColor(.black)

                            Spacer()

                            Text(toneMarking.toneVisual)
                                .font(.system(size: 28))
                                .foregroundColor(.black)
                        }

                        Button {
                            audioManager.playWord(thaiWord: word.core.thai)
                            isPlayingA = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                isPlayingA = false
                            }
                        } label: {
                            HStack {
                                Image(systemName: isPlayingA ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                                    .font(.system(size: 20))

                                Text(localization.localize("tone.lesson.listen_correct"))
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

                    // VS
                    VStack(spacing: 0) {
                        Divider()
                        Text(localization.localize("tone.lesson.vs"))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.vertical, 8)
                        Divider()
                    }

                    // Tone B (Contrastive)
                    if showComparison {
                        VStack(spacing: 12) {
                            HStack {
                                Text("\(localization.localize("tone.lesson.tone2_rising"))")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black)

                                Spacer()

                                Text("╱")  // Rising visual
                                    .font(.system(size: 28))
                                    .foregroundColor(.black)
                            }

                            Button {
                                audioManager.playToneVariant(word: word.core.thai, tone: "rising")
                                isPlayingB = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    isPlayingB = false
                                }
                            } label: {
                                HStack {
                                    Image(systemName: isPlayingB ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
                                        .font(.system(size: 20))

                                    Text(localization.localize("tone.lesson.listen_different"))
                                        .font(.body)
                                        .fontWeight(.semibold)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(red: 0.2, green: 0.8, blue: 1.0))
                                .cornerRadius(8)
                            }
                            .foregroundColor(.white)

                            Text(localization.localize("tone.lesson.notice_difference"))
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        .padding()
                        .background(Color(red: 0.95, green: 0.9, blue: 0.85))
                        .cornerRadius(8)
                        .transition(.opacity.combined(with: .scale))
                    } else {
                        Button {
                            withAnimation {
                                showComparison = true
                            }
                        } label: {
                            HStack {
                                Image(systemName: "waveform.circle.fill")
                                    .font(.system(size: 20))

                                Text(localization.localize("tone.lesson.show_comparison"))
                                    .font(.body)
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.2, green: 0.8, blue: 1.0))
                            .cornerRadius(8)
                        }
                        .foregroundColor(.white)
                    }

                    // Explanation
                    VStack(alignment: .leading, spacing: 8) {
                        Text(localization.localize("tone.lesson.why_matters"))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)

                        Text(localization.localize("tone.lesson.importance"))
                            .font(.caption)
                            .lineLimit(nil)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .background(Color(red: 1.0, green: 0.95, blue: 0.8))
                    .cornerRadius(8)
                }
                .padding()
            }

            NavigationLink(destination: ToneDetectionQuizView(wordId: word.id)) {
                HStack {
                    Text(localization.localize("tone.lesson.test_ear"))
                        .font(.body)
                        .fontWeight(.semibold)

                    Spacer()

                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .cornerRadius(8)
                .foregroundColor(.white)
            }
            .padding()
            }
        }
        .navigationTitle(localization.localize("tone.lesson.title"))
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ToneLessonView(
            toneMarking: ToneMarking(
                wordId: "cat",
                thai: "แมว",
                romanizationRTGS: "maew",
                romanizationTone: "mɛ̂ː",
                toneNumber: 2,
                toneName: "falling",
                syllables: [
                    ToneSyllable(
                        thai: "แมว",
                        romanization: "maew",
                        tone: "falling",
                        ipa: "mɛ̂ː",
                        consonantClass: "mid",
                        vowel: "ɛː",
                        toneNumber: 2
                    )
                ]
            ),
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
            )
        )
    }
}
