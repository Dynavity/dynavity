import CoreGraphics
import Foundation

struct MarkupTextBlock: TextBlock {
    enum MarkupType: String, CaseIterable {
        case plaintext, markdown, latex

        var displayName: String {
            switch self {
            case .plaintext:
                return "Plain Text"
            case .markdown:
                return "Markdown"
            case .latex:
                return "LaTeX"
            }
        }
    }

    var id = UUID()
    var text: String = ""
    var visualID: String {
        id.uuidString + "\(text.hashValue)"
    }

    // TODO: update these with actual values
    var position: CGPoint = .zero
    var fontSize: CGFloat = 14

    var markupType: MarkupType = .plaintext
}
