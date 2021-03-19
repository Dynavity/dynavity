import PDFKit
import SwiftUI

struct PDFCanvasElementView: UIViewRepresentable {
    typealias UIViewType = PDFView

    @ObservedObject var viewModel: PDFCanvasElementViewModel

    init(pdfCanvasElement: PDFCanvasElement) {
        self.viewModel = PDFCanvasElementViewModel(pdfCanvasElement: pdfCanvasElement)
    }

    func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: viewModel.pdfCanvasElement.url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing.
    }
}
