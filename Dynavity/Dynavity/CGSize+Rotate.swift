import SwiftUI

extension CGSize {
    func rotate(by rotation: CGFloat) -> CGSize {
        let rotatedWidth = self.width * cos(rotation) - self.height * sin(rotation)
        let rotatedHeight = self.width * sin(rotation) + self.height * cos(rotation)
        return CGSize(width: rotatedWidth, height: rotatedHeight)
    }
}
