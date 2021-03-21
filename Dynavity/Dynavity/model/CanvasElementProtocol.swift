import Foundation
import CoreGraphics

protocol CanvasElementProtocol {
    var id: UUID { get }
    var position: CGPoint { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }
    var rotation: Double { get set }
    var minimumWidth: CGFloat { get }
    var minimumHeight: CGFloat { get }

    mutating func move(by translation: CGSize)
    mutating func resize(by translation: CGSize)
    mutating func rotate(to rotation: Double)
}

// MARK: Default implementations
extension CanvasElementProtocol {
    var minimumWidth: CGFloat {
        30.0
    }
    var minimumHeight: CGFloat {
        30.0
    }

    mutating func move(by translation: CGSize) {
        self.position += translation
    }

    mutating func resize(by translation: CGSize) {
        self.width = max(self.width + translation.width, minimumWidth)
        self.height = max(self.height + translation.height, minimumHeight)
    }

    mutating func rotate(to rotation: Double) {
        self.rotation = rotation
    }
}
