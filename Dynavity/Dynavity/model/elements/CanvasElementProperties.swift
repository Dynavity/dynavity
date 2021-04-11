import SwiftUI

struct CanvasElementProperties {
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var minimumWidth: CGFloat = 30.0
    var minimumHeight: CGFloat = 30.0
}

// MARK: Default implementations
extension CanvasElementProperties {
    mutating func move(by translation: CGSize) {
        self.position += translation
    }

    mutating func resize(by translation: CGSize) {
        self.width = max(self.width + translation.width, self.minimumWidth)
        self.height = max(self.height + translation.height, self.minimumHeight)
    }

    mutating func rotate(to rotation: Double) {
        self.rotation = rotation
    }

    /// The point input has taken into account the offset from the `CanvasView`
    func containsPoint(_ point: CGPoint) -> Bool {
        let frame = CGRect(origin: CGPoint(x: position.x - (width / 2),
                                           y: position.y - (height / 2)),
                           size: CGSize(width: width, height: height)
                            .rotate(by: CGFloat(rotation)))
        return frame.contains(point)
    }
}

// MARK: Unit test helpers
extension CanvasElementProperties {
    // Corners are with reference to 0 rotation. Corners are consistent throughout rotation.
    // For example, topRightCorner might be at bottom left in view when element is rotated
    var topRightCorner: CGPoint {
        let xPosition = position.x + ((width / 2) * CGFloat(cos(rotation))) + ((height / 2) * CGFloat(sin(rotation)))
        let yPosition = position.y + ((width / 2) * CGFloat(sin(rotation))) - ((height / 2) * CGFloat(cos(rotation)))
        return CGPoint(x: xPosition,
                       y: yPosition)
    }

    var topLeftCorner: CGPoint {
        let xPosition = position.x - ((width / 2) * CGFloat(cos(rotation))) + ((height / 2) * CGFloat(sin(rotation)))
        let yPosition = position.y - ((width / 2) * CGFloat(sin(rotation))) - ((height / 2) * CGFloat(cos(rotation)))
        return CGPoint(x: xPosition,
                       y: yPosition)
    }

    var bottomLeftCorner: CGPoint {
        let xPosition = position.x - ((width / 2) * CGFloat(cos(rotation))) - ((height / 2) * CGFloat(sin(rotation)))
        let yPosition = position.y - ((width / 2) * CGFloat(sin(rotation))) + ((height / 2) * CGFloat(cos(rotation)))
        return CGPoint(x: xPosition,
                       y: yPosition)
    }

    var bottomRightCorner: CGPoint {
        let xPosition = position.x + ((width / 2) * CGFloat(cos(rotation))) - ((height / 2) * CGFloat(sin(rotation)))
        let yPosition = position.y + ((width / 2) * CGFloat(sin(rotation))) + ((height / 2) * CGFloat(cos(rotation)))
        return CGPoint(x: xPosition,
                       y: yPosition)
    }

    var topMostPoint: CGPoint {
        let points = [topRightCorner, bottomLeftCorner, bottomRightCorner]
        return points.reduce(topLeftCorner, { $0.y < $1.y ? $0 : $1 })
    }

    var bottomMostPoint: CGPoint {
        let points = [topRightCorner, bottomLeftCorner, bottomRightCorner]
        return points.reduce(topLeftCorner, { $0.y > $1.y ? $0 : $1 })
    }

    var leftMostPoint: CGPoint {
        let points = [topRightCorner, bottomLeftCorner, bottomRightCorner]
        return points.reduce(topLeftCorner, { $0.x < $1.x ? $0 : $1 })
    }

    var rightMostPoint: CGPoint {
        let points = [topRightCorner, bottomLeftCorner, bottomRightCorner]
        return points.reduce(topLeftCorner, { $0.x > $1.x ? $0 : $1 })
    }
}
