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
        canvasProperties.move(by: translation)
    }

    func resize(by translation: CGSize) {
        canvasProperties.resize(by: translation)
    }

    func rotate(to rotation: Double) {
        canvasProperties.rotate(to: rotation)
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
