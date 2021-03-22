import CoreGraphics
import Foundation

struct MarkupElement: CanvasElementProtocol {
    enum MarkupType: String {
        case markdown, latex
    }

    var textBlock: TextElement
    var markupType: MarkupType

    init(position: CGPoint, markupType: MarkupType) {
        self.textBlock = TextElement(position: position)
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
    var width: CGFloat {
        get {
            textBlock.width
        }
        set {
            textBlock.width = newValue
        }
    }
    var height: CGFloat {
        get {
            textBlock.height
        }
        set {
            textBlock.height = newValue
        }
    }
    var rotation: Double {
        get {
            textBlock.rotation
        }
        set {
            textBlock.rotation = newValue
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

extension MarkupElement: Equatable {}
