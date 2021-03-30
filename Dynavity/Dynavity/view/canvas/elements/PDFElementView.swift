import PDFKit
import SwiftUI

struct PDFElementView: UIViewRepresentable {
    typealias UIViewType = PDFView

    @StateObject private var viewModel: PDFElementViewModel

    init(pdfElement: PDFElement) {
        self._viewModel = StateObject(wrappedValue:
                                        PDFElementViewModel(pdfElement: pdfElement))
    }

    func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: viewModel.pdfElement.file)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing.
    }
}
