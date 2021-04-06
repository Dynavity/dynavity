import CoreGraphics
import Foundation

class PlainTextElement: ObservableObject, CanvasElementProtocol, TextElementProtocol {
    @Published var canvasProperties: CanvasElementProperties
    var text: String

    init(position: CGPoint) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.text = ""
    }
}
