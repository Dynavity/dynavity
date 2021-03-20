import CoreGraphics
import Foundation

struct TextBlock: CanvasElementProtocol {
    // TODO: replace these with actual values
    var id = UUID()
    var position: CGPoint
    var text: String = ""
    var fontSize: CGFloat = 14
}

extension TextBlock: Equatable {}
