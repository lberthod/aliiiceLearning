import SwiftUI

struct CommonMistakeCard: View {
    let mistake: CommonMistake
    @EnvironmentObject var gameState: GameState
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header - Incorrect/Correct comparison
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("❌ Incorrect")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.red)
                        .textCase(.uppercase)

                    Text(mistake.incorrectThai)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }

                Spacer()

                Image(systemName: "arrow.right")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.yellow)

                Spacer()

                VStack(alignment: .trailing, spacing: 6) {
                    Text("✅ Correct")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.green)
                        .textCase(.uppercase)

                    Text(mistake.correctThai)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .background(Color.white.opacity(0.12))

            // Expandable explanation
            VStack(spacing: 0) {
                Button(action: { withAnimation { isExpanded.toggle() } }) {
                    HStack(spacing: 8) {
                        Text("Why?")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.cyan)

                        Spacer()

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.cyan)
                    }
                    .padding(10)
                    .background(Color.cyan.opacity(0.1))
                }

                if isExpanded {
                    VStack(alignment: .leading, spacing: 8) {
                        Divider()
                            .background(Color.white.opacity(0.2))

                        Text(gameState.selectedLanguage == "fr" ? mistake.explanationFr : mistake.explanationEn)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.9))
                            .lineSpacing(2)
                    }
                    .padding(12)
                    .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
        }
        .background(Color.white.opacity(0.08))
        .cornerRadius(10)
    }
}

#Preview {
    CommonMistakeCard(
        mistake: grammarTopicsData[1].commonMistakes[0]
    )
    .environmentObject(GameState())
    .padding()
    .background(Color.blue)
}
