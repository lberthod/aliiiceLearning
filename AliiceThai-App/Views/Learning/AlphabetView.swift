import SwiftUI

struct ThaiAlphabetItem: Identifiable, Hashable {
    let letter: String
    let name: String
    let romanization: String
    let consonantClass: String
    let cue: String

    var id: String { letter }
}

let thaiAlphabet: [ThaiAlphabetItem] = [
    ThaiAlphabetItem(letter: "ก", name: "Ko Kai", romanization: "k", consonantClass: "Mid", cue: "chicken"),
    ThaiAlphabetItem(letter: "ข", name: "Kho Khai", romanization: "kh", consonantClass: "High", cue: "egg"),
    ThaiAlphabetItem(letter: "ฃ", name: "Kho Khuat", romanization: "kh", consonantClass: "High", cue: "bottle, obsolete"),
    ThaiAlphabetItem(letter: "ค", name: "Kho Khwai", romanization: "kh", consonantClass: "Low", cue: "buffalo"),
    ThaiAlphabetItem(letter: "ฅ", name: "Kho Khon", romanization: "kh", consonantClass: "Low", cue: "person, obsolete"),
    ThaiAlphabetItem(letter: "ฆ", name: "Kho Rakhang", romanization: "kh", consonantClass: "Low", cue: "bell"),
    ThaiAlphabetItem(letter: "ง", name: "Ngo Ngu", romanization: "ng", consonantClass: "Low", cue: "snake"),
    ThaiAlphabetItem(letter: "จ", name: "Cho Chan", romanization: "ch", consonantClass: "Mid", cue: "plate"),
    ThaiAlphabetItem(letter: "ฉ", name: "Cho Ching", romanization: "ch", consonantClass: "High", cue: "cymbals"),
    ThaiAlphabetItem(letter: "ช", name: "Cho Chang", romanization: "ch", consonantClass: "Low", cue: "elephant"),
    ThaiAlphabetItem(letter: "ซ", name: "So So", romanization: "s", consonantClass: "Low", cue: "chain"),
    ThaiAlphabetItem(letter: "ฌ", name: "Cho Choe", romanization: "ch", consonantClass: "Low", cue: "tree"),
    ThaiAlphabetItem(letter: "ญ", name: "Yo Ying", romanization: "y", consonantClass: "Low", cue: "woman"),
    ThaiAlphabetItem(letter: "ฎ", name: "Do Chada", romanization: "d", consonantClass: "Mid", cue: "headdress"),
    ThaiAlphabetItem(letter: "ฏ", name: "To Patak", romanization: "t", consonantClass: "Mid", cue: "goad"),
    ThaiAlphabetItem(letter: "ฐ", name: "Tho Than", romanization: "th", consonantClass: "High", cue: "pedestal"),
    ThaiAlphabetItem(letter: "ฑ", name: "Tho Nangmontho", romanization: "th", consonantClass: "Low", cue: "Montho"),
    ThaiAlphabetItem(letter: "ฒ", name: "Tho Phuthao", romanization: "th", consonantClass: "Low", cue: "elder"),
    ThaiAlphabetItem(letter: "ณ", name: "No Nen", romanization: "n", consonantClass: "Low", cue: "novice monk"),
    ThaiAlphabetItem(letter: "ด", name: "Do Dek", romanization: "d", consonantClass: "Mid", cue: "child"),
    ThaiAlphabetItem(letter: "ต", name: "To Tao", romanization: "t", consonantClass: "Mid", cue: "turtle"),
    ThaiAlphabetItem(letter: "ถ", name: "Tho Thung", romanization: "th", consonantClass: "High", cue: "bag"),
    ThaiAlphabetItem(letter: "ท", name: "Tho Thahan", romanization: "th", consonantClass: "Low", cue: "soldier"),
    ThaiAlphabetItem(letter: "ธ", name: "Tho Thong", romanization: "th", consonantClass: "Low", cue: "flag"),
    ThaiAlphabetItem(letter: "น", name: "No Nu", romanization: "n", consonantClass: "Low", cue: "mouse"),
    ThaiAlphabetItem(letter: "บ", name: "Bo Baimai", romanization: "b", consonantClass: "Mid", cue: "leaf"),
    ThaiAlphabetItem(letter: "ป", name: "Po Pla", romanization: "p", consonantClass: "Mid", cue: "fish"),
    ThaiAlphabetItem(letter: "ผ", name: "Pho Phueng", romanization: "ph", consonantClass: "High", cue: "bee"),
    ThaiAlphabetItem(letter: "ฝ", name: "Fo Fa", romanization: "f", consonantClass: "High", cue: "lid"),
    ThaiAlphabetItem(letter: "พ", name: "Pho Phan", romanization: "ph", consonantClass: "Low", cue: "tray"),
    ThaiAlphabetItem(letter: "ฟ", name: "Fo Fan", romanization: "f", consonantClass: "Low", cue: "teeth"),
    ThaiAlphabetItem(letter: "ภ", name: "Pho Samphao", romanization: "ph", consonantClass: "Low", cue: "sailboat"),
    ThaiAlphabetItem(letter: "ม", name: "Mo Ma", romanization: "m", consonantClass: "Low", cue: "horse"),
    ThaiAlphabetItem(letter: "ย", name: "Yo Yak", romanization: "y", consonantClass: "Low", cue: "giant"),
    ThaiAlphabetItem(letter: "ร", name: "Ro Ruea", romanization: "r", consonantClass: "Low", cue: "boat"),
    ThaiAlphabetItem(letter: "ล", name: "Lo Ling", romanization: "l", consonantClass: "Low", cue: "monkey"),
    ThaiAlphabetItem(letter: "ว", name: "Wo Waen", romanization: "w", consonantClass: "Low", cue: "ring"),
    ThaiAlphabetItem(letter: "ศ", name: "So Sala", romanization: "s", consonantClass: "High", cue: "pavilion"),
    ThaiAlphabetItem(letter: "ษ", name: "So Rusi", romanization: "s", consonantClass: "High", cue: "hermit"),
    ThaiAlphabetItem(letter: "ส", name: "So Suea", romanization: "s", consonantClass: "High", cue: "tiger"),
    ThaiAlphabetItem(letter: "ห", name: "Ho Hip", romanization: "h", consonantClass: "High", cue: "chest"),
    ThaiAlphabetItem(letter: "ฬ", name: "Lo Chula", romanization: "l", consonantClass: "Low", cue: "kite"),
    ThaiAlphabetItem(letter: "อ", name: "O Ang", romanization: "o", consonantClass: "Mid", cue: "basin"),
    ThaiAlphabetItem(letter: "ฮ", name: "Ho Nokhuk", romanization: "h", consonantClass: "Low", cue: "owl")
]

struct AlphabetView: View {
    @EnvironmentObject var gameState: GameState
    @ObservedObject var localization = LocalizationManager.shared
    @Environment(\.presentationMode) var presentationMode
    @State private var audioOnCooldown: Set<String> = []

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.9, green: 0.6, blue: 0.2), Color(red: 0.8, green: 0.4, blue: 0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(
                    title: localization.localize("alphabet.title"),
                    subtitle: "\(thaiAlphabet.count) " + localization.localize("alphabet.letters")
                )

                // Alphabet Grid
                ScrollView {
                    VStack(spacing: 12) {
                        NavigationLink(destination: AlphabetGameView()) {
                            HStack(spacing: 14) {
                                Image(systemName: "play.fill")
                                    .font(.system(size: 18, weight: .bold))
                                    .foregroundColor(.orange)
                                    .frame(width: 48, height: 48)
                                    .background(Color.white)
                                    .cornerRadius(12)

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(localization.localize("alphabet.sprint_title"))
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                    Text(localization.localize("alphabet.sprint_description"))
                                        .font(.system(size: 13, weight: .medium))
                                        .foregroundColor(.white.opacity(0.82))
                                        .lineLimit(2)
                                }

                                Spacer()

                                Image(systemName: "chevron.right")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                            .padding(16)
                            .background(Color.black.opacity(0.22))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.22), lineWidth: 1)
                            )
                        }

                        ForEach(thaiAlphabet, id: \.letter) { item in
                            Button(action: {
                                AudioManager.shared.speakThai(item.letter)
                                audioOnCooldown.insert(item.letter)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    audioOnCooldown.remove(item.letter)
                                }
                            }) {
                                HStack(spacing: 16) {
                                    Text(item.letter)
                                        .font(.system(size: 40, weight: .bold))
                                        .foregroundColor(.white)
                                        .frame(width: 60)

                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(item.name)
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                        Text(item.romanization)
                                            .font(.system(size: 14))
                                            .foregroundColor(.white.opacity(0.7))
                                        Text("\(consonantClassLabel(item.consonantClass)) • \(item.cue)")
                                            .font(.system(size: 12, weight: .medium))
                                            .foregroundColor(.white.opacity(0.62))
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.75)
                                    }

                                    Spacer()

                                    Image(systemName: "speaker.wave.2.fill")
                                        .font(.system(size: 20))
                                        .foregroundColor(.white)
                                        .frame(width: 50, height: 50)
                                        .background(Color.white.opacity(0.2))
                                        .cornerRadius(10)
                                }
                                .padding(16)
                                .background(Color.white.opacity(0.15))
                                .cornerRadius(12)
                            }
                            .disabled(audioOnCooldown.contains(item.letter))
                            .opacity(audioOnCooldown.contains(item.letter) ? 0.5 : 1.0)
                        }
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }

    private func consonantClassLabel(_ consonantClass: String) -> String {
        let key = "alphabet.class_\(consonantClass.lowercased())"
        return localization.localize(key)
    }
}

#Preview {
    AlphabetView()
        .environmentObject(GameState())
}
