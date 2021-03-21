import PDFKit
import SwiftUI

struct PDFCanvasElementView: UIViewRepresentable {
    typealias UIViewType = PDFView

    @StateObject private var viewModel: PDFCanvasElementViewModel

    init(pdfCanvasElement: PDFCanvasElement) {
        self._viewModel = StateObject(wrappedValue:
                                        PDFCanvasElementViewModel(pdfCanvasElement: pdfCanvasElement))
    }

    func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: viewModel.pdfCanvasElement.file)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing.
    }
}
