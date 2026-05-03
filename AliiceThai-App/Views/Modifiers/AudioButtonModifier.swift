import SwiftUI

struct AudioButtonCooldown: ViewModifier {
    @State private var isOnCooldown = false

    func body(content: Content) -> some View {
        content
            .disabled(isOnCooldown)
            .opacity(isOnCooldown ? 0.5 : 1.0)
            .onChange(of: isOnCooldown) { _, newValue in
                if newValue {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        isOnCooldown = false
                    }
                }
            }
            .simultaneousGesture(
                TapGesture().onEnded {
                    if !isOnCooldown {
                        isOnCooldown = true
                    }
                }
            )
    }
}

extension View {
    func audioButtonCooldown() -> some View {
        self.modifier(AudioButtonCooldown())
    }
}
