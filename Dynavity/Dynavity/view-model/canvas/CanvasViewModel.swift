import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()

    // Selected media
    @Published var selectedImage: UIImage? {
        didSet {
            addImageCanvasElement()
        }
    }
    @Published var selectedFile: URL? {
        didSet {
            addPdfCanvasElement()
        }
    }

    func addImageCanvasElement() {
        guard let image = selectedImage else {
            return
        }

        let imageCanvasElement = ImageCanvasElement(image: image)
        canvas.addElement(imageCanvasElement)

        // Reset the selected image.
        selectedImage = nil
    }

    func addPdfCanvasElement() {
        guard let file = selectedFile else {
            return
        }

        let pdfCanvasElement = PDFCanvasElement(file: file)
        canvas.addElement(pdfCanvasElement)

        // Reset the selected file.
        selectedFile = nil
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
