import SwiftUI

class PDFElementViewModel: ObservableObject {
    @Published var pdfElement: PDFElement

    init(pdfElement: PDFElement) {
        self.pdfElement = pdfElement
    }
}
