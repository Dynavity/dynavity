import SwiftUI

extension CGPoint {
    static func + (firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
        CGPoint(x: firstPoint.x + secondPoint.x, y: firstPoint.y + secondPoint.y)
    }

    static func - (firstPoint: CGPoint, secondPoint: CGPoint) -> CGPoint {
        CGPoint(x: firstPoint.x - secondPoint.x, y: firstPoint.y - secondPoint.y)
    }

    static func + (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x + size.width, y: point.y + size.height)
    }

    static func - (point: CGPoint, size: CGSize) -> CGPoint {
        CGPoint(x: point.x - size.width, y: point.y - size.height)
    }

    static func + (firstPoint: CGPoint, secondPoint: CGPoint) -> CGSize {
        CGSize(width: firstPoint.x + secondPoint.x, height: firstPoint.y + secondPoint.y)
    }

    static func - (firstPoint: CGPoint, secondPoint: CGPoint) -> CGSize {
        CGSize(width: firstPoint.x - secondPoint.x, height: firstPoint.y - secondPoint.y)
    }

    static func += (point: inout CGPoint, size: CGSize) {
        point.x += size.width
        point.y += size.height
    }
}
