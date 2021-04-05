import SwiftUI

class PDFElement: CanvasElementProtocol {
    var canvasProperties: CanvasElementProperties
    var file: URL

    init(position: CGPoint, file: URL) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.file = file
    }
}
