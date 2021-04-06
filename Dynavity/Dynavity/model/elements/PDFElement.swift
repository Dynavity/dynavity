import Combine
import SwiftUI

class PDFElement: ObservableObject, CanvasElementProtocol {
    @Published var canvasProperties: CanvasElementProperties
    var file: URL

    init(position: CGPoint, file: URL) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.file = file
    }
}
