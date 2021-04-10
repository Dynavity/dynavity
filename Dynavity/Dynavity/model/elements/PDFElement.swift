import Combine
import SwiftUI
import PDFKit

class PDFElement: ObservableObject, CanvasElementProtocol {
    @Published var canvasProperties: CanvasElementProperties
    var pdfDocument: PDFDocument

    init(position: CGPoint, pdfDocument: PDFDocument) {
        self.canvasProperties = CanvasElementProperties(position: position)
        self.pdfDocument = pdfDocument
    }
}
