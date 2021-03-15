import SwiftUI

extension View {
    func addCardOverlay() -> some View {
        self.background(Rectangle().fill(Color.white).shadow(radius: 8))
    }
}
