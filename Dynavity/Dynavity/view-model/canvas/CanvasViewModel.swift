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

    // Reposition drag gesture
    private var dragStartLocation: CGPoint?
    private var element: CanvasElementProtocol?

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
        guard let element = canvas.getElementBy(id: selectedCanvasElementId) else {
            return
        }

        let rotation = element.rotation
        let rotatedTranslation = translation.rotate(by: CGFloat(rotation))
        canvas.moveCanvasElement(id: selectedCanvasElementId, by: rotatedTranslation)
    }

    private func resizeSelectedCanvasElement(by translation: CGSize, anchor: SelectionOverlayView.ResizeControlAnchor) {
        guard var element = element,
              let originalElement = self.element else {
            return
        }

        let resizeTranslation: CGSize = {
            switch anchor {
            case .topLeftCorner:
                return CGSize(width: -translation.width, height: -translation.height)
            case .topRightCorner:
                return CGSize(width: translation.width, height: -translation.height)
            case .bottomLeftCorner:
                return CGSize(width: -translation.width, height: translation.height)
            case .bottomRightCorner:
                return translation
            }
        }()
        element.resize(by: resizeTranslation)

        var clampedTranslation = translation
        // Clamp x-axis if necessary.
        if element.width == element.minimumWidth {
            let actualWidth = originalElement.width + resizeTranslation.width
            let widthDelta = element.minimumWidth - actualWidth
            if anchor == .topLeftCorner || anchor == .bottomLeftCorner {
                clampedTranslation.width -= widthDelta
            } else {
                clampedTranslation.width += widthDelta
            }
        }
        // Clamp y-axis if necessary.
        if element.height == element.minimumHeight {
            let actualHeight = originalElement.height + resizeTranslation.height
            let heightDelta = element.minimumHeight - actualHeight
            if anchor == .topLeftCorner || anchor == .topRightCorner {
                clampedTranslation.height -= heightDelta
            } else {
                clampedTranslation.height += heightDelta
            }
        }

        let rotation = element.rotation
        let centerTranslation = clampedTranslation.rotate(by: CGFloat(rotation)) / 2.0
        element.move(by: centerTranslation)

        canvas.replaceElement(element)
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
        let rotatedTranslation = translation.rotate(by: CGFloat(currentRotation))

        // Transform the rotation angle from the x-axis to the y-axis.
        let rotationOffset = Double.pi / 2.0
        let rotation = Double(atan2(rotatedTranslation.height, rotatedTranslation.width)) + rotationOffset

        canvas.rotateCanvasElement(id: selectedCanvasElementId, to: rotation)
    }
}

// MARK: Reposition drag gesture
extension CanvasViewModel {
    func handleDragChange(_ value: DragGesture.Value, anchor: SelectionOverlayView.ResizeControlAnchor) {
        if dragStartLocation == nil {
            guard let element = canvas.getElementBy(id: selectedCanvasElementId) else {
                return
            }
            dragStartLocation = value.startLocation
            self.element = element
        }

        guard let dragStartLocation = dragStartLocation,
              let element = element else {
            return
        }

        let translation: CGSize = (value.location - dragStartLocation) / scaleFactor
        let rotatedTranslation = translation.rotate(by: -CGFloat(element.rotation))
        resizeSelectedCanvasElement(by: rotatedTranslation, anchor: anchor)
    }

    func handleDragEnd() {
        dragStartLocation = nil
        element = nil
    }
}
