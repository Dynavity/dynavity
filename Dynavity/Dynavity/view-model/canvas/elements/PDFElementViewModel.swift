import SwiftUI

class PDFElementViewModel: ObservableObject {
    @Published var pdfCanvasElement: PDFElement

    init(pdfCanvasElement: PDFElement) {
        self.pdfCanvasElement = pdfCanvasElement
    }
}
