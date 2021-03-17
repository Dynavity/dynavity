import CoreGraphics
import Foundation

struct MarkupTextBlock: CanvasElementProtocol {
    enum MarkupType: String {
        case markdown, latex
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
    var visualID: String {
        textBlock.visualID
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

    var textBlock = TextBlock()
    var markupType: MarkupType = .markdown
}

extension MarkupTextBlock: Equatable {}
