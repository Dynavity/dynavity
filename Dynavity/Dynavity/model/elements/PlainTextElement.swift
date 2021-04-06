import CoreGraphics
import Foundation

class PlainTextElement: ObservableObject, CanvasElementProtocol {
    @Published var canvasProperties: CanvasElementProperties
    var text: String
    var fontSize: CGFloat = 14

    init(position: CGPoint) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.text = ""
    }
}
