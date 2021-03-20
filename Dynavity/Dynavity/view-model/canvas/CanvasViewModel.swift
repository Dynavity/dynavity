import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()

    func addImageCanvasElement(from image: UIImage) {
        let imageCanvasElement = ImageCanvasElement(image: image)
        canvas.addElement(imageCanvasElement)
    }

    func addPdfCanvasElement(from file: URL) {
        let pdfCanvasElement = PDFCanvasElement(file: file)
        canvas.addElement(pdfCanvasElement)
    }

    func addTextBlock() {
        canvas.addElement(TextBlock())
    }

    func addMarkUpTextBlock(markupType: MarkupTextBlock.MarkupType) {
        canvas.addElement(MarkupTextBlock(markupType: markupType))
    }

    func storeAnnotation(_ drawing: PKDrawing) {
        annotationCanvas.drawing = drawing
    }
}
