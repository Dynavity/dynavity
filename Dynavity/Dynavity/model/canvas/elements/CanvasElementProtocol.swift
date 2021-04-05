import Foundation
import CoreGraphics

protocol CanvasElementProtocol: Codable {
    var canvasProperties: CanvasElementProperties { set get }

    mutating func move(by translation: CGSize)
    mutating func resize(by translation: CGSize)
    mutating func rotate(to rotation: Double)
}

// MARK: Default implementations
extension CanvasElementProtocol {
    mutating func move(by translation: CGSize) {
        self.canvasProperties.position += translation
    }

    mutating func resize(by translation: CGSize) {
        self.canvasProperties.width =
            max(self.canvasProperties.width + translation.width, self.canvasProperties.minimumWidth)
        self.canvasProperties.height =
            max(self.canvasProperties.height + translation.height, self.canvasProperties.minimumHeight)
    }

    mutating func rotate(to rotation: Double) {
        self.canvasProperties.rotation = rotation
    }
}
