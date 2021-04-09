import Combine
import CoreGraphics
import Foundation

class MarkupElement: PlainTextElement {
    // TODO: look into removing codable for this and updating DTO to store a primitive instead
    enum MarkupType: String, Codable {
        case markdown, latex
    }

    var markupType: MarkupType

    init(position: CGPoint, markupType: MarkupType) {
        self.markupType = markupType
        super.init(position: position)
    }
}
