import CoreGraphics
import Foundation

struct MarkupElement: TextElementProtocol {
    enum MarkupType: String, Codable {
        case markdown, latex
    }

    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var observers = [ElementChangeListener]()

    // MARK: TextElementProtocol
    var text: String = "" {
        didSet { notifyObservers() }
    }

    // MARK: MarkupElement-specific attributes
    var markupType: MarkupType {
        didSet { notifyObservers() }
    }

    init(position: CGPoint, markupType: MarkupType) {
        self.position = position
        self.markupType = markupType
    }
}

extension MarkupElement: Codable {
    private enum CodingKeys: CodingKey {
        case id, position, width, height, rotation, text, markupType
    }
}

extension MarkupElement: Equatable {
    static func == (lhs: MarkupElement, rhs: MarkupElement) -> Bool {
        lhs.checkId(rhs)
    }
}
