import SwiftUI

extension View {
    func shouldAddCardOverlay(shouldAdd: Bool) -> some View {
        let color = shouldAdd ? Color.white : Color.clear
        return self.background(Rectangle().fill(color).shadow(radius: 8))
    }
}
