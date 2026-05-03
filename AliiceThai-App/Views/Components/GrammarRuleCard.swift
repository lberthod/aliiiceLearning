import SwiftUI

struct GrammarRuleCard: View {
    let rule: GrammarRule
    @EnvironmentObject var gameState: GameState
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Rule header (clickable)
            Button(action: { withAnimation { isExpanded.toggle() } }) {
                HStack(spacing: 12) {
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.yellow)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(gameState.selectedLanguage == "fr" ? rule.ruleFr : rule.ruleEn)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                    }

                    Spacer()

                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .animation(.easeInOut, value: isExpanded)
                }
                .padding(16)
            }

            // Expanded explanation
            if isExpanded {
                Divider()
                    .background(Color.white.opacity(0.3))

                VStack(alignment: .leading, spacing: 12) {
                    Text("Explanation")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                        .textCase(.uppercase)

                    Text(gameState.selectedLanguage == "fr" ? rule.explanationFr : rule.explanation)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(4)
                }
                .padding(16)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color.white.opacity(0.15))
        .cornerRadius(12)
    }
}

#Preview {
    GrammarRuleCard(rule: grammarTopicsData[0].rules[0])
        .environmentObject(GameState())
        .padding()
        .background(Color.blue)
}
