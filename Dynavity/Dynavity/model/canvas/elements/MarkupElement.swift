import CoreGraphics
import Foundation

class MarkupElement: CanvasElementProtocol, TextElementProtocol {
    enum MarkupType: String, Codable {
        case markdown, latex
    }

    // MARK: CanvasElementProtocol
    var canvasProperties: CanvasElementProperties

    // MARK: TextElementProtocol
    var text: String = ""

    // MARK: MarkupElement-specific attributes
    var markupType: MarkupType

    init(position: CGPoint, markupType: MarkupType) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.markupType = markupType
    }
}
