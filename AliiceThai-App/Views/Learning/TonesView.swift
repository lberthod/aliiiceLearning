import SwiftUI

struct TonesView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var gameViewModel = GameViewModel.shared
    @ObservedObject var localization = LocalizationManager.shared

    @State private var selectedMode: ToneMode = .lesson
    @State private var isLoading = true
    @State private var toneMarkings: [ToneMarking] = []

    enum ToneMode {
        case lesson
        case quiz
        case weak
    }

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
                HeaderView(
                    title: localization.localize("tone.mastery.title"),
                    subtitle: localization.localize("tone.mastery.subtitle"),
                    showBackButton: false,
                    showHomeButton: true
                )

                // Mode tabs
                HStack(spacing: 12) {
                    ModeTab(
                        label: localization.localize("tone.lesson"),
                        labelFr: localization.localize("tone.lesson"),
                        isSelected: selectedMode == .lesson,
                        action: { selectedMode = .lesson }
                    )
                    ModeTab(
                        label: localization.localize("tone.quiz"),
                        labelFr: localization.localize("tone.quiz"),
                        isSelected: selectedMode == .quiz,
                        action: { selectedMode = .quiz }
                    )
                    ModeTab(
                        label: localization.localize("tone.weak_areas"),
                        labelFr: localization.localize("tone.weak_areas"),
                        isSelected: selectedMode == .weak,
                        action: { selectedMode = .weak }
                    )
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)

                if isLoading {
                    VStack {
                        ProgressView().scaleEffect(1.5).tint(.white)
                        Text(localization.localize("tone.lesson_list.loading")).font(.caption).foregroundColor(.white)
                    }
                    .frame(maxHeight: .infinity)
                    .padding()
                } else {
                    Group {
                        if selectedMode == .lesson {
                            ToneLessonsListView(toneMarkings: toneMarkings)
                        } else if selectedMode == .quiz {
                            ToneDetectionQuizView(wordId: nil)
                        } else {
                            WeakTonesView(weakTones: gameState.getWeakTones())
                        }
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                }
            }

            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            loadToneData()
        }
    }

    private func loadToneData() {
        if let wrappedWords = JSONWordParser.shared.loadWordsFromJSON() {
            ToneMarkingData.shared.buildFromWrappedWords(wrappedWords)
            toneMarkings = ToneMarkingData.shared.getAllToneMarkings()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                isLoading = false
            }
        } else {
            print("❌ Failed to load wrapped words for tones")
            isLoading = false
        }
    }
}

// MARK: - Tone Lessons List View

struct ToneLessonsListView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var gameViewModel = GameViewModel.shared
    @ObservedObject var localization = LocalizationManager.shared
    let toneMarkings: [ToneMarking]

    var toneSummary: [String: Int] {
        var summary: [String: Int] = [:]
        for tone in ["mid", "low", "falling", "rising", "high"] {
            summary[tone] = toneMarkings.filter { $0.toneName == tone }.count
        }
        return summary
    }

    var body: some View {
        VStack(spacing: 12) {
            Text(localization.localize("tone.lesson_list.learn_each"))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 16)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(["mid", "low", "falling", "rising", "high"], id: \.self) { toneName in
                        NavigationLink {
                            ToneLessonForToneView(toneName: toneName, words: getWordsForTone(toneName))
                        } label: {
                            ToneLessonCard(
                                toneName: toneName,
                                wordCount: toneSummary[toneName] ?? 0,
                                accuracy: gameState.getToneAccuracy(wordId: toneName)
                            )
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
        }
    }

    func getWordsForTone(_ toneName: String) -> [WrappedWord] {
        // Filter wrapped words by tone
        return gameViewModel.wrappedWords.filter { word in
            word.linguistic.syllables.first?.tone == toneName
        }
    }
}

struct ToneLessonCard: View {
    @ObservedObject var localization = LocalizationManager.shared
    let toneName: String
    let wordCount: Int
    let accuracy: Int

    var toneVisual: String {
        switch toneName {
        case "mid": return "━━━"
        case "low": return "╲╲╲"
        case "falling": return "╲"
        case "rising": return "╱"
        case "high": return "━"
        default: return ""
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(localization.localize("tone.name.\(toneName.lowercased())"))
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Text("\(wordCount) \(localization.localize("tone.lesson_list.words"))")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }

                Spacer()

                Text(toneVisual)
                    .font(.system(size: 28))
                    .foregroundColor(.black)
            }

            if accuracy > 0 {
                HStack(spacing: 8) {
                    ProgressView(value: Double(accuracy), total: 100)
                        .tint(Color(red: 0.2, green: 0.8, blue: 0.2))

                    Text("\(accuracy)%")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                }
            } else {
                Text(localization.localize("tone.lesson_list.not_started"))
                    .font(.caption2)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(red: 0.95, green: 0.9, blue: 0.85))
        .cornerRadius(8)
    }
}

// MARK: - Tone Lesson For Tone

struct ToneLessonForToneView: View {
    @ObservedObject var localization = LocalizationManager.shared
    let toneName: String
    let words: [WrappedWord]

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

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                Text("\(localization.localize("tone.lesson_for_tone.title")) \(localization.localize("tone.name.\(toneName.lowercased())").uppercased())")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Text(localization.localize("tone.lesson_for_tone.subtitle"))
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)

                ForEach(words.prefix(12), id: \.id) { word in
                    NavigationLink {
                        ToneLessonView(
                            toneMarking: ToneMarkingData.shared.getToneMarking(wordId: word.id) ?? ToneMarking(
                                wordId: word.id,
                                thai: word.core.thai,
                                romanizationRTGS: word.core.romanization.rtgs,
                                romanizationTone: word.core.romanization.with_tone,
                                toneNumber: 1,
                                toneName: toneName,
                                syllables: []
                            ),
                            word: word
                        )
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(word.core.thai)
                                    .font(.body)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)

                                Text(word.core.translation.fr)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.black)
                            }

                            Spacer()

                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2))
                        }
                        .padding()
                        .background(Color(red: 0.95, green: 0.9, blue: 0.85))
                        .cornerRadius(8)
                    }
                }

                if words.isEmpty {
                    Text(localization.localize("tone.lesson_for_tone.no_words"))
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding()
                }

                Spacer()
                }
                .padding()
            }
        }
        .navigationTitle("\(localization.localize("tone.lesson_for_tone.title")) \(localization.localize("tone.name.\(toneName.lowercased())"))")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - Weak Tones View

struct WeakTonesView: View {
    @ObservedObject var gameState = GameState.shared
    @ObservedObject var localization = LocalizationManager.shared
    let weakTones: Set<String>

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

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                if weakTones.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.green)

                        Text(localization.localize("tone.weak.great_job"))
                            .font(.headline)

                        Text(localization.localize("tone.weak.no_weak"))
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                } else {
                    Text(localization.localize("tone.weak.title"))
                        .font(.headline)
                        .foregroundColor(.brown)

                    Text(localization.localize("tone.weak.subtitle"))
                        .font(.caption)
                        .foregroundColor(.gray)

                    ForEach(weakTones.sorted(), id: \.self) { wordId in
                        WeakToneCard(wordId: wordId, accuracy: gameState.getToneAccuracy(wordId: wordId))
                    }
                }
                }
                .padding()
            }
        }
    }
}

struct WeakToneCard: View {
    @ObservedObject var localization = LocalizationManager.shared
    let wordId: String
    let accuracy: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(wordId)
                    .font(.body)
                    .fontWeight(.bold)
                    .foregroundColor(.black)

                Spacer()

                Text("\(accuracy)%")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 1.0, green: 0.6, blue: 0.2))
            }

            ProgressView(value: Double(accuracy), total: 100)
                .tint(Color(red: 1.0, green: 0.6, blue: 0.2))

            Text(localization.localize("tone.weak.focus"))
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.black)
        }
        .padding()
        .background(Color(red: 1.0, green: 0.95, blue: 0.85))
        .cornerRadius(8)
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        TonesView()
    }
}
