import Foundation
import CoreGraphics

protocol CanvasElementProtocol {
    var id: UUID { get }
    var position: CGPoint { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }
    var rotation: Double { get set }

    mutating func move(by translation: CGSize)
    mutating func rotate(to rotation: Double)
}

// MARK: Default implementations
extension CanvasElementProtocol {
    mutating func move(by translation: CGSize) {
        self.position += translation
    }

    mutating func rotate(to rotation: Double) {
        self.rotation = rotation
    }
}
