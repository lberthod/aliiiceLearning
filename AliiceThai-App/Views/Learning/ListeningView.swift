import SwiftUI

struct ListeningView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @ObservedObject var localization = LocalizationManager.shared
    let word: WrappedWord

    @State var selectedSpeed: Float = 1.0

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

            VStack(spacing: 20) {
                // Title
                Text(localization.localize("listening.practice.title"))
                    .font(.headline)
                    .foregroundColor(.white)

                ScrollView {
                    VStack(spacing: 20) {
                        // Word display
                        VStack(spacing: 12) {
                            Text(word.core.thai)
                                .font(.system(size: 56, weight: .bold))
                                .foregroundColor(.white)

                            Text(word.core.romanization.with_tone)
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))

                            if let en = word.core.translation.en as? String {
                                Text(en)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(12)

                        // Speed controls section
                        VStack(alignment: .leading, spacing: 12) {
                            Text(localization.localize("listening.speed.choose"))
                                .font(.caption)
                                .foregroundColor(.white.opacity(0.7))

                            HStack(spacing: 12) {
                                SpeedButton(label: "Slow", speed: 0.5, selectedSpeed: $selectedSpeed)
                                SpeedButton(label: "Normal", speed: 0.75, selectedSpeed: $selectedSpeed)
                                SpeedButton(label: "Fast", speed: 1.0, selectedSpeed: $selectedSpeed)
                            }
                        }
                        .padding(16)
                        .background(Color.white.opacity(0.08))
                        .cornerRadius(12)

                        // Play button
                        VStack(spacing: 15) {
                            Button {
                                audioManager.playWord(thaiWord: word.core.thai)
                            } label: {
                                VStack(spacing: 8) {
                                    Image(systemName: "speaker.wave.3.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))

                                    Text(localization.localize("listening.play_button"))
                                        .font(.caption)
                                        .foregroundColor(.white)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(12)
                            }

                            // Speed indicator
                            HStack {
                                Text(localization.localize("listening.current_speed"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.7))

                                Spacer()

                                Text("\(String(format: "%.2f", selectedSpeed))x")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundColor(Color(red: 1.0, green: 0.75, blue: 0.3))
                            }
                            .padding(.horizontal)
                        }

                        // Tips section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Image(systemName: "lightbulb.fill")
                                    .foregroundColor(.yellow)
                                    .font(.caption)

                                Text(localization.localize("listening.tip"))
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                        }
                        .padding(12)
                        .background(Color.yellow.opacity(0.1))
                        .cornerRadius(8)

                        Spacer()
                    }
                    .padding(16)
                }
            }
        }
        .navigationBarBackButtonHidden(false)
    }
}

struct SpeedButton: View {
    let label: String
    let speed: Float
    @Binding var selectedSpeed: Float

    var body: some View {
        Button {
            selectedSpeed = speed
        } label: {
            VStack(spacing: 4) {
                Text(label)
                    .font(.caption)
                    .fontWeight(.semibold)

                Text("\(String(format: "%.2f", speed))x")
                    .font(.caption2)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                selectedSpeed == speed
                    ? Color(red: 1.0, green: 0.75, blue: 0.3)
                    : Color.white.opacity(0.1)
            )
            .foregroundColor(selectedSpeed == speed ? .black : .white)
            .cornerRadius(8)
        }
    }
}

#Preview {
    Text("Preview not available")
}
