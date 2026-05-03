import SwiftUI

struct AudioButton<Label: View>: View {
    @State private var isOnCooldown = false
    let action: () -> Void
    let label: () -> Label

    var body: some View {
        Button(action: {
            action()
            isOnCooldown = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isOnCooldown = false
            }
        }) {
            label()
        }
        .disabled(isOnCooldown)
        .opacity(isOnCooldown ? 0.5 : 1.0)
    }
}

// Convenience for simple text labels
struct SimpleAudioButton: View {
    @State private var isOnCooldown = false
    let action: () -> Void
    let icon: String

    var body: some View {
        Button(action: {
            action()
            isOnCooldown = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                isOnCooldown = false
            }
        }) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
        }
        .disabled(isOnCooldown)
        .opacity(isOnCooldown ? 0.5 : 1.0)
    }
}
