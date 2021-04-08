import Combine
import CoreGraphics
import Foundation

class MarkupElement: PlainTextElement {
    enum MarkupType: String, Codable {
        case markdown, latex
    }

    var markupType: MarkupType

    init(position: CGPoint, markupType: MarkupType) {
        self.markupType = markupType
        super.init(position: position)
    }
}
