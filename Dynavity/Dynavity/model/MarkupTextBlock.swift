import CoreGraphics
import Foundation

struct MarkupTextBlock: TextBlock {
    enum MarkupType: String {
        case markdown, latex
    }

    var id = UUID()
    var text: String = ""
    var visualID: String {
        id.uuidString + "\(text.hashValue)"
    }

    // TODO: update these with actual values
    var position: CGPoint = .zero
    var fontSize: CGFloat = 14

    let markupType: MarkupType = .latex
}
