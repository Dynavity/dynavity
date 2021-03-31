import SwiftUI

extension CGSize {
    static func - (firstSize: CGSize, secondSize: CGSize) -> CGSize {
        CGSize(width: firstSize.width - secondSize.width, height: firstSize.height - secondSize.height)
    }

    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    static func /= (size: inout CGSize, scalar: CGFloat) {
        size.width /= scalar
        size.height /= scalar
    }
}
