import CoreGraphics
import Foundation

struct PlainTextElement: TextElementProtocol {
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var observers = [ElementChangeListener]()

    // MARK: TextElementProtocol
    var text: String = ""
}

extension PlainTextElement: Codable {
    private enum CodingKeys: CodingKey {
        case id, position, width, height, rotation, text
    }
}
