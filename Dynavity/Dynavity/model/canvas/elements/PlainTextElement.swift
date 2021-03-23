import CoreGraphics
import Foundation

struct PlainTextElement: TextElementProtocol {
    // TODO: Replace these with actual values
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero

    // MARK: TextElementProtocol
    var text: String = ""
}

extension PlainTextElement: Equatable {}
