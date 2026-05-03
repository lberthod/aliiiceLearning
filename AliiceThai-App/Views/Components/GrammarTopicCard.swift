import SwiftUI

struct GrammarTopicCard: View {
    let topic: GrammarTopic
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                Text(topic.icon)
                    .font(.system(size: 32))

                VStack(alignment: .leading, spacing: 4) {
                    Text(gameState.selectedLanguage == "fr" ? topic.titleFr : topic.titleEn)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    Text(gameState.selectedLanguage == "fr" ? topic.descriptionFr : topic.descriptionEn)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.8))
                }

                Spacer()

                VStack(spacing: 4) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)

                    Text("\(topic.examples.count)")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                }
            }

            // Preview examples
            VStack(alignment: .leading, spacing: 6) {
                ForEach(topic.examples.prefix(2), id: \.thai) { example in
                    HStack(spacing: 8) {
                        Circle()
                            .fill(Color.white.opacity(0.5))
                            .frame(width: 6, height: 6)

                        VStack(alignment: .leading, spacing: 2) {
                            Text(example.thai)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            Text(example.romanization)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.7))
                        }

                        Spacer()

                        Text(gameState.selectedLanguage == "fr" ? example.frenchTranslation : example.englishTranslation)
                            .font(.system(size: 11))
                            .foregroundColor(.yellow)
                            .lineLimit(1)
                    }
                }
            }
        }
        .padding(16)
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}

#Preview {
    GrammarTopicCard(topic: grammarTopicsData[0])
        .environmentObject(GameState())
        .padding()
}
