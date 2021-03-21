import SwiftUI

extension CGSize {
    static func / (size: CGSize, scalar: CGFloat) -> CGSize {
        CGSize(width: size.width / scalar, height: size.height / scalar)
    }

    static func /= (size: inout CGSize, scalar: CGFloat) {
        size.width /= scalar
        size.height /= scalar
    }
}
