import CoreGraphics
import Foundation

struct MarkupElement: TextElementProtocol {
    enum MarkupType: String {
        case markdown, latex
    }

    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero

    // MARK: TextElementProtocol
    var text: String = ""

    // MARK: MarkupElement-specific attributes
    var markupType: MarkupType

    init(position: CGPoint, markupType: MarkupType) {
        self.position = position
        self.markupType = markupType
    }
}

extension MarkupElement: Equatable {}
