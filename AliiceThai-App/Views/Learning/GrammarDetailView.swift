import SwiftUI

struct GrammarDetailView: View {
    let topic: GrammarTopic
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.6, green: 0.4, blue: 0.9), Color(red: 0.8, green: 0.6, blue: 0.4)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Custom Header
                HStack(spacing: 16) {
                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.white)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(gameState.selectedLanguage == "fr" ? topic.titleFr : topic.titleEn)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)

                        Text(gameState.selectedLanguage == "fr" ? topic.descriptionFr : topic.descriptionEn)
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.8))
                    }

                    Spacer()

                    Text(topic.icon)
                        .font(.system(size: 32))
                }
                .padding(16)
                .background(Color.black.opacity(0.2))

                // Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Rules Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                Text("Key Rules")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)

                            ForEach(topic.rules, id: \.ruleEn) { rule in
                                GrammarRuleCard(rule: rule)
                                    .environmentObject(gameState)
                                    .padding(.horizontal, 16)
                            }
                        }

                        // Patterns Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "square.grid.2x2")
                                    .foregroundColor(.cyan)
                                Text("Syntax Patterns")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)

                            ForEach(topic.patterns, id: \.patternEn) { pattern in
                                GrammarPatternCard(pattern: pattern)
                                    .environmentObject(gameState)
                                    .padding(.horizontal, 16)
                            }
                        }

                        // Examples Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "text.quote")
                                    .foregroundColor(.green)
                                Text("Examples")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)

                            ForEach(topic.examples, id: \.thai) { example in
                                GrammarExampleCard(example: example)
                                    .environmentObject(gameState)
                                    .padding(.horizontal, 16)
                            }
                        }

                        // Common Mistakes Section
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 8) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .foregroundColor(.orange)
                                Text("Common Mistakes")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 16)

                            ForEach(topic.commonMistakes, id: \.incorrectThai) { mistake in
                                CommonMistakeCard(mistake: mistake)
                                    .environmentObject(gameState)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.vertical, 16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    NavigationStack {
        GrammarDetailView(topic: grammarTopicsData[0])
            .environmentObject(GameState())
    }
}
