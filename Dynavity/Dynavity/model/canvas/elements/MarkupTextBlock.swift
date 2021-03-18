import CoreGraphics
import Foundation

struct MarkupTextBlock: CanvasElementProtocol {
    enum MarkupType: String {
        case markdown, latex
    }

    var textBlock = TextBlock()
    var markupType: MarkupType = .markdown

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
