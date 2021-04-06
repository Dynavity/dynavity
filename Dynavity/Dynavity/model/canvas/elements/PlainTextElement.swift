import CoreGraphics
import Foundation

class PlainTextElement: CanvasElementProtocol, TextElementProtocol {
    var canvasProperties: CanvasElementProperties
    var text: String

    init(position: CGPoint) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.text = ""
    }
}
