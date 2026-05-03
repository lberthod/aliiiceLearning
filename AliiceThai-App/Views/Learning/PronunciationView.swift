import SwiftUI

struct PronunciationView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var loc = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode

    let tones: [(tone: String, toneFr: String, icon: String, description: String, descriptionFr: String, examples: [String])] = [
        (
            tone: "Mid Tone",
            toneFr: "Ton Moyen",
            icon: "➡️",
            description: "Natural, flat pitch",
            descriptionFr: "Ton plat naturel",
            examples: ["ไม่ (mai)", "บ้าน (baan)"]
        ),
        (
            tone: "Low Tone",
            toneFr: "Ton Bas",
            icon: "📉",
            description: "Lower pitch",
            descriptionFr: "Ton bas",
            examples: ["ค่า (kha)", "เก่า (kao)"]
        ),
        (
            tone: "Falling Tone",
            toneFr: "Ton Descendant",
            icon: "⬇️",
            description: "Falls from high to low",
            descriptionFr: "Descend du haut au bas",
            examples: ["ไก่ (kai)", "ม้า (ma)"]
        ),
        (
            tone: "Rising Tone",
            toneFr: "Ton Montant",
            icon: "⬆️",
            description: "Rises from low to high",
            descriptionFr: "Remonte du bas au haut",
            examples: ["ช้า (cha)", "เนื้อ (neua)"]
        ),
        (
            tone: "High Tone",
            toneFr: "Ton Aigu",
            icon: "📈",
            description: "High and level pitch",
            descriptionFr: "Ton aigu et plat",
            examples: ["ขาว (khao)", "มา (ma)"]
        ),
    ]

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.9, green: 0.4, blue: 0.4), Color(red: 0.9, green: 0.6, blue: 0.2)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(
                    title: gameState.selectedLanguage == "fr" ? "Prononciation" : "Pronunciation",
                    subtitle: "\(tones.count) " + (gameState.selectedLanguage == "fr" ? "tons" : "tones")
                )

                // Tones List
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(tones, id: \.tone) { tone in
                            VStack(alignment: .leading, spacing: 12) {
                                HStack(spacing: 12) {
                                    Text(tone.icon)
                                        .font(.system(size: 36))

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(gameState.selectedLanguage == "fr" ? tone.toneFr : tone.tone)
                                            .font(.system(size: 18, weight: .bold))
                                            .foregroundColor(.white)
                                        Text(gameState.selectedLanguage == "fr" ? tone.descriptionFr : tone.description)
                                            .font(.system(size: 13))
                                            .foregroundColor(.white.opacity(0.8))
                                    }

                                    Spacer()

                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 18))
                                        .foregroundColor(.white)
                                        .frame(width: 45, height: 45)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(10)
                                }

                                // Examples
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(gameState.selectedLanguage == "fr" ? "Exemples:" : "Examples:")
                                        .font(.system(size: 12, weight: .semibold))
                                        .foregroundColor(.white.opacity(0.8))

                                    ForEach(tone.examples, id: \.self) { example in
                                        HStack(spacing: 8) {
                                            Circle()
                                                .fill(Color.white.opacity(0.4))
                                                .frame(width: 5, height: 5)
                                            Text(example)
                                                .font(.system(size: 13))
                                                .foregroundColor(.white.opacity(0.9))
                                        }
                                    }
                                }
                                .padding(12)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(8)
                            }
                            .padding(16)
                            .background(Color.white.opacity(0.15))
                            .cornerRadius(12)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PronunciationView()
        .environmentObject(GameState())
}
