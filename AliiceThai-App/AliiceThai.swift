import SwiftUI

@main
struct AliiceThai: App {
    @StateObject var gameState = GameState()
    @StateObject var gameViewModel = GameViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                if gameState.hasCompletedOnboarding {
                    HomeView()
                } else {
                    OnboardingView()
                }
            }
            .environmentObject(gameState)
            .environmentObject(gameViewModel)
            .preferredColorScheme(nil)
        }
    }
}
