import SwiftUI

struct GrammarPatternCard: View {
    let pattern: GrammarPattern
    @EnvironmentObject var gameState: GameState

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Pattern label
            HStack(spacing: 8) {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                    .font(.system(size: 14))
                    .foregroundColor(.cyan)

                Text(gameState.selectedLanguage == "fr" ? pattern.patternFr : pattern.patternEn)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)

                Spacer()
            }

            Divider()
                .background(Color.white.opacity(0.2))

            // Example
            VStack(alignment: .leading, spacing: 6) {
                Text("Example")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.white.opacity(0.7))
                    .textCase(.uppercase)

                Text(pattern.example)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.yellow)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.yellow.opacity(0.1))
                    .cornerRadius(8)
            }

            // Description
            Text(pattern.description)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.8))
                .lineSpacing(2)
        }
        .padding(12)
        .background(Color.white.opacity(0.08))
        .cornerRadius(10)
    }
}

#Preview {
    GrammarPatternCard(
        pattern: grammarTopicsData[1].patterns[0]
    )
    .environmentObject(GameState())
    .padding()
    .background(Color.blue)
}
