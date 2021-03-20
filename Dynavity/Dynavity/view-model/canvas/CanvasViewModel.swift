import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()
    @Published var scaleFactor: CGFloat = 1.0
    @Published var selectedCanvasElementId: UUID?

    init(canvas: Canvas) {
        self.canvas = canvas
    }

    convenience init() {
        self.init(canvas: Canvas())
    }

    func select(canvasElement: CanvasElementProtocol) {
        if selectedCanvasElementId == canvasElement.id {
            selectedCanvasElementId = nil
            return
        }
        selectedCanvasElementId = canvasElement.id
    }

    func unselectCanvasElement() {
        selectedCanvasElementId = nil
    }

    func moveSelectedCanvasElement(to location: CGPoint) {
        canvas.repositionCanvasElement(id: selectedCanvasElementId, to: location)
    }

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
