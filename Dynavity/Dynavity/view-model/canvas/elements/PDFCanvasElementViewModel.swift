import SwiftUI

class PDFCanvasElementViewModel: ObservableObject {
    @Published var pdfCanvasElement: PDFCanvasElement

    init(pdfCanvasElement: PDFCanvasElement) {
        self.pdfCanvasElement = pdfCanvasElement
    }
}
