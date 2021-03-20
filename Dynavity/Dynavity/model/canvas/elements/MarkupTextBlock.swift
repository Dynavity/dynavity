import CoreGraphics
import Foundation

struct MarkupTextBlock: CanvasElementProtocol {
    enum MarkupType: String {
        case markdown, latex
    }

    var textBlock: TextBlock
    var markupType: MarkupType

    init(position: CGPoint, markupType: MarkupType) {
        self.textBlock = TextBlock(position: position)
        self.markupType = markupType
    }

    var id: UUID {
        textBlock.id
    }
    var position: CGPoint {
        get {
            textBlock.position
        }
        set {
            textBlock.position = newValue
        }
    }
    var text: String {
        get {
            textBlock.text
        }
        set {
            textBlock.text = newValue
        }
    }
    var fontSize: CGFloat {
        textBlock.fontSize
    }
}

extension MarkupTextBlock: Equatable {}
