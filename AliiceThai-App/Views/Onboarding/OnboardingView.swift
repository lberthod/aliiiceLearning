import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var gameState: GameState
    @State private var currentScreen = 0

    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color(red: 0.2, green: 0.3, blue: 0.8), Color(red: 0.8, green: 0.2, blue: 0.6)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack {
                TabView(selection: $currentScreen) {
                    // Screen 1: Welcome
                    OnboardingScreen1()
                        .tag(0)

                    // Screen 2: Demo
                    OnboardingScreen2()
                        .tag(1)

                    // Screen 3: Language Selection
                    OnboardingScreen3()
                        .tag(2)

                    // Screen 4: Ready
                    OnboardingScreen4()
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

                HStack(spacing: 20) {
                    if currentScreen > 0 {
                        Button(action: { withAnimation { currentScreen -= 1 } }) {
                            Text(gameState.getLocalizedString("Back", "Retour"))
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 60)
                                .background(Color.gray)
                                .cornerRadius(15)
                        }
                    }

                    Button(action: {
                        if currentScreen < 3 {
                            withAnimation { currentScreen += 1 }
                        } else {
                            gameState.completeOnboarding()
                        }
                    }) {
                        Text(currentScreen < 3 ? gameState.getLocalizedString("Next", "Suivant") : gameState.getLocalizedString("Let's Go!", "C'est parti !"))
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 60)
                            .background(Color(red: 0.2, green: 0.8, blue: 0.4))
                            .cornerRadius(15)
                    }
                }
                .padding(20)
            }
        }
        .onChange(of: currentScreen) { _ in
            AudioManager.shared.playTapSound()
        }
    }
}

struct OnboardingScreen1: View {
    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("🎓")
                .font(.system(size: 120))
                .scaleEffect(isAnimating ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: isAnimating)
                .onAppear { isAnimating = true }

            Text("Learn Thai with AliiceThai!")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)

            Text("Tap emojis, tap words, learn and have fun!")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.9))
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding(30)
    }
}

struct OnboardingScreen2: View {
    @State private var demoWord: Word = Word(id: "demo-cat", emoji: "🐱", thai: "แมว", romanization: "maew", english: "cat", french: "chat", category: "animals")

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            Text("How to Learn")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)

            VStack(spacing: 40) {
                // Tap emoji to hear
                VStack(spacing: 10) {
                    Button(action: { AudioManager.shared.speakThai(demoWord.thai) }) {
                        Text(demoWord.emoji)
                            .font(.system(size: 100))
                            .scaleEffect(1.0)
                    }
                    Text("Tap emoji to hear the word!")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }

                // Tap word to hear translation
                VStack(spacing: 10) {
                    Button(action: { AudioManager.shared.speakEnglish(demoWord.english) }) {
                        Text(demoWord.thai)
                            .font(.system(size: 32, weight: .bold))
                            .foregroundColor(.white)
                            .padding(15)
                            .background(Color.white.opacity(0.2))
                            .cornerRadius(10)
                    }
                    Text("Tap word to hear translation!")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .multilineTextAlignment(.center)
                }
            }

            Spacer()
        }
        .padding(30)
    }
}

struct OnboardingScreen3: View {
    @EnvironmentObject var gameState: GameState

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("Choose Language")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.white)

            HStack(spacing: 20) {
                Button(action: {
                    gameState.selectedLanguage = "en"
                    AudioManager.shared.playCategorySelectSound()
                }) {
                    VStack(spacing: 15) {
                        Text("🇬🇧")
                            .font(.system(size: 60))
                        Text("English")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(gameState.selectedLanguage == "en" ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.white.opacity(0.2))
                    .cornerRadius(20)
                }

                Button(action: {
                    gameState.selectedLanguage = "fr"
                    AudioManager.shared.playCategorySelectSound()
                }) {
                    VStack(spacing: 15) {
                        Text("🇫🇷")
                            .font(.system(size: 60))
                        Text("Français")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 150)
                    .background(gameState.selectedLanguage == "fr" ? Color(red: 0.2, green: 0.8, blue: 0.4) : Color.white.opacity(0.2))
                    .cornerRadius(20)
                }
            }

            Spacer()
        }
        .padding(30)
    }
}

struct OnboardingScreen4: View {
    @State private var showConfetti = false

    var body: some View {
        VStack(spacing: 30) {
            Spacer()

            if showConfetti {
                ConfettiView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            VStack(spacing: 20) {
                Text("🌟")
                    .font(.system(size: 80))
                    .scaleEffect(showConfetti ? 1.2 : 1.0)

                Text("Ready to Learn!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)

                Text("Let's start learning Thai together!")
                    .font(.system(size: 18))
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding(30)
        .onAppear {
            withAnimation {
                showConfetti = true
            }
            AudioManager.shared.playCelebrationSound()
        }
    }
}

struct ConfettiView: View {
    @State private var particlees: [Particle] = (0..<30).map { _ in Particle() }

    var body: some View {
        Canvas { context, size in
            for particle in particlees {
                var path = Path()
                path.addEllipse(in: CGRect(x: particle.x, y: particle.y, width: 10, height: 10))

                context.fill(path, with: .color(particle.color))
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 2.0)) {
                particlees.forEach { particle in
                    particle.y += 400
                }
            }
        }
    }
}

class Particle: Identifiable {
    let id = UUID()
    var x: CGFloat = CGFloat.random(in: 0..<400)
    var y: CGFloat = -50
    var color: Color {
        let colors: [Color] = [.red, .yellow, .green, .blue, .purple, .pink, .orange]
        return colors.randomElement() ?? .red
    }
}

#Preview {
    OnboardingView()
        .environmentObject(GameState())
}
