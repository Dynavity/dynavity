import Foundation
import CoreGraphics

protocol CanvasElementProtocol: AnyObservableObject {
    var canvasProperties: CanvasElementProperties { get set }

    func move(by translation: CGSize)
    func resize(by translation: CGSize)
    func rotate(to rotation: Double)
}

// MARK: Default implementations
extension CanvasElementProtocol {
    func move(by translation: CGSize) {
        self.canvasProperties.position += translation
    }

    func resize(by translation: CGSize) {
        self.canvasProperties.width =
            max(self.canvasProperties.width + translation.width, self.canvasProperties.minimumWidth)
        self.canvasProperties.height =
            max(self.canvasProperties.height + translation.height, self.canvasProperties.minimumHeight)
    }

    func rotate(to rotation: Double) {
        self.canvasProperties.rotation = rotation
    }
}

// MARK: Properties
extension CanvasElementProtocol {
    var position: CGPoint {
        get { canvasProperties.position }
        set { canvasProperties.position = newValue }
    }

    var width: CGFloat {
        get { canvasProperties.width }
        set { canvasProperties.width = newValue }
    }

    var height: CGFloat {
        get { canvasProperties.height }
        set { canvasProperties.height = newValue }
    }

    var rotation: Double {
        get { canvasProperties.rotation }
        set { canvasProperties.rotation = newValue }
    }

    var minimumWidth: CGFloat {
        canvasProperties.minimumWidth
    }

    var minimumHeight: CGFloat {
        canvasProperties.minimumHeight
    }

    var topRightCorner: CGPoint {
        canvasProperties.topRightCorner
    }

    var topLeftCorner: CGPoint {
        canvasProperties.topLeftCorner
    }

    var bottomLeftCorner: CGPoint {
        canvasProperties.bottomLeftCorner
    }

    var bottomRightCorner: CGPoint {
        canvasProperties.bottomRightCorner
    }

    var topMostPoint: CGPoint {
        canvasProperties.topMostPoint
    }

    var bottomMostPoint: CGPoint {
        canvasProperties.bottomMostPoint
    }

    var leftMostPoint: CGPoint {
        canvasProperties.leftMostPoint
    }

    var rightMostPoint: CGPoint {
        canvasProperties.rightMostPoint
    }

    func containsPoint(_ point: CGPoint) -> Bool {
        canvasProperties.containsPoint(point)
    }
}
