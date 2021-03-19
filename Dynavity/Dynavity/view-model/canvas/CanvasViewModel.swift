import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()
    @Published var selectedImage: UIImage?

    func addImageCanvasElement() {
        guard let image = selectedImage else {
            return
        }

        let imageCanvasElement = ImageCanvasElement(image: image)
        canvas.addElement(imageCanvasElement)

        // Reset the selected image.
        selectedImage = nil
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
