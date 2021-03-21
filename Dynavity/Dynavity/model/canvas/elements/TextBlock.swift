import CoreGraphics
import Foundation

struct TextBlock: CanvasElementProtocol {
    // TODO: replace these with actual values
    var id = UUID()
    var position: CGPoint
    var text: String = ""
    var fontSize: CGFloat = 14
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
}

extension TextBlock: Equatable {}
