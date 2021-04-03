import SwiftUI
import PencilKit

class CanvasViewModel: ObservableObject {
    enum CanvasMode {
        case selection
        case pen
        case marker
        case eraser
        case lasso
    }

    @Published var canvas = Canvas()
    @Published var annotationCanvas = AnnotationCanvas()
    @Published var annotationPalette = AnnotationPalette()
    @Published var canvasSize: CGFloat
    @Published var canvasTopLeftOffset: CGPoint = .zero
    @Published var scaleFactor: CGFloat = 1.0
    @Published var selectedCanvasElementId: UUID?
    @Published var canvasMode: CanvasMode {
        didSet {
            // Reset canvas element selection on selecting some other mode.
            if oldValue == .selection && canvasMode != oldValue {
                selectedCanvasElementId = nil
            }
        }
    }
    @Published var shouldShowAnnotationMenu = false
    @Published var shouldShowUmlMenu = false

    // Uml element connectors
    @Published var selectedUmlConnectorId: UUID?
    @Published var umlConnectorStart: (umlElement: UmlElementProtocol, anchor: ConnectorConnectingSide)?
    @Published var umlConnectorEnd: (umlElement: UmlElementProtocol, anchor: ConnectorConnectingSide)?
    var canvasViewport: CGSize = .zero

    // Reposition drag gesture
    private var dragStartLocation: CGPoint?
    private var element: CanvasElementProtocol?

    var canvasOrigin: CGPoint {
        CGPoint(x: canvasSize / 2.0, y: canvasSize / 2.0)
    }

    private var originOffset: CGPoint {
        canvasTopLeftOffset - canvasOrigin
    }

    private var scaledOriginOffset: CGPoint {
        canvasTopLeftOffset / scaleFactor - canvasOrigin
    }

    private var viewportOffset: CGSize {
        canvasViewport / 2.0 * (scaleFactor - 1.0)
    }

    var canvasViewportOffset: CGSize {
        viewportOffset - originOffset - canvasOrigin
    }

    private var canvasCenter: CGPoint {
        canvasOrigin - viewportOffset / scaleFactor + scaledOriginOffset
    }

    init(canvasSize: CGFloat) {
        self.canvasSize = canvasSize
        self.canvasMode = .pen
    }

    convenience init() {
        // Arbitrarily large value for the "infinite" canvas.
        self.init(canvasSize: 500_000)
    }

    func getCanvasElements() -> [CanvasElementProtocol] {
        canvas.canvasElements
    }

    func setCanvasViewport(size: CGSize) {
        canvasViewport = size
    }
}

// MARK: Adding of canvas elements
extension CanvasViewModel {
    func addImageElement(from image: UIImage) {
        let imageCanvasElement = ImageElement(position: canvasCenter, image: image)
        canvas.addElement(imageCanvasElement)
    }

    func addPdfElement(from file: URL) {
        let pdfCanvasElement = PDFElement(position: canvasCenter, file: file)
        canvas.addElement(pdfCanvasElement)
    }

    func addTodoElement() {
        canvas.addElement(TodoElement(position: canvasCenter))
    }

    func addPlainTextElement() {
        canvas.addElement(PlainTextElement(position: canvasCenter))
    }

    func addCodeElement() {
        canvas.addElement(CodeElement(position: canvasCenter))
    }

    func addMarkupElement(markupType: MarkupElement.MarkupType) {
        canvas.addElement(MarkupElement(position: canvasCenter, markupType: markupType))
    }

    func storeAnnotation(_ drawing: PKDrawing) {
        annotationCanvas.drawing = drawing
    }

    func addUmlElement(umlElement: UmlElementProtocol) {
        // TODO: Apply factory pattern here
        switch umlElement.umlShape {
        case .diamond:
            canvas.addElement(DiamondUmlElement(position: canvasCenter))
        case .rectangle:
            canvas.addElement(RectangleUmlElement(position: canvasCenter))
        }
    }
}

// MARK: Editing/deleting of canvas elements
extension CanvasViewModel {
    func select(canvasElement: CanvasElementProtocol) {
        if selectedCanvasElementId == canvasElement.id {
            selectedCanvasElementId = nil
            umlConnectorStart = nil
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

    func removeElement(_ element: CanvasElementProtocol) {
        canvas.removeElement(element)
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
