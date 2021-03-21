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
}

// MARK: Adding of canvas elements
extension CanvasViewModel {
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

// MARK: Editing/deleting of canvas elements
extension CanvasViewModel {
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

    func moveSelectedCanvasElement(by translation: CGSize) {
        canvas.moveCanvasElement(id: selectedCanvasElementId, by: translation)
    }

    func rotateSelectedCanvasElement(by translation: CGSize) {
        // Prevent excessive spinning when dragging near the center of the canvas element.
        let deadZone: CGFloat = 15.0
        guard abs(translation.height) > deadZone else {
            return
        }

        guard let element = canvas.getElementBy(id: selectedCanvasElementId) else {
            return
        }

        let currentRotation = element.rotation
        let rotatedTranslationX = translation.width * CGFloat(cos(currentRotation))
            - translation.height * CGFloat(sin(currentRotation))
        let rotatedTranslationY = translation.width * CGFloat(sin(currentRotation))
            + translation.height * CGFloat(cos(currentRotation))

        // Transform the rotation angle from the x-axis to the y-axis.
        let rotationOffset = Double.pi / 2.0
        let rotation = Double(atan2(rotatedTranslationY, rotatedTranslationX)) + rotationOffset

        canvas.rotateCanvasElement(id: selectedCanvasElementId, to: rotation)
    }
}
