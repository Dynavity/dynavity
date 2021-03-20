import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()
    @Published var canvasSize: CGFloat
    @Published var canvasCenterOffsetX: CGFloat = 0.0
    @Published var canvasCenterOffsetY: CGFloat = 0.0
    @Published var scaleFactor: CGFloat = 1.0
    @Published var selectedCanvasElementId: UUID?

    var canvasOrigin: CGPoint {
        CGPoint(x: canvasSize / 2.0, y: canvasSize / 2.0)
    }

    init(canvasSize: CGFloat) {
        self.canvasSize = canvasSize
    }

    convenience init() {
        // Arbitrarily large value for the "infinite" canvas.
        self.init(canvasSize: 500_000)
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
        let imageCanvasElement = ImageCanvasElement(position: canvasOrigin, image: image)
        canvas.addElement(imageCanvasElement)
    }

    func addPdfCanvasElement(from file: URL) {
        let pdfCanvasElement = PDFCanvasElement(position: canvasOrigin, file: file)
        canvas.addElement(pdfCanvasElement)
    }

    func addTextBlock() {
        canvas.addElement(TextBlock(position: canvasOrigin))
    }

    func addMarkUpTextBlock(markupType: MarkupTextBlock.MarkupType) {
        canvas.addElement(MarkupTextBlock(position: canvasOrigin, markupType: markupType))
    }

    func storeAnnotation(_ drawing: PKDrawing) {
        annotationCanvas.drawing = drawing
    }
}
