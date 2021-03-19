import PDFKit
import SwiftUI

struct PDFKitView: UIViewRepresentable {
    typealias UIViewType = PDFView

    let url: URL

    func makeUIView(context: Context) -> UIViewType {
        let pdfView = PDFView()
        pdfView.document = PDFDocument(url: url)
        pdfView.autoScales = true
        return pdfView
    }

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Do nothing.
    }
}
