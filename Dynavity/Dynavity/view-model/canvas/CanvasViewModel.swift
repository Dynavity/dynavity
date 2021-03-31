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
    @Published var canvasCenterOffsetX: CGFloat = 0.0
    @Published var canvasCenterOffsetY: CGFloat = 0.0
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
    @Published var umlConnectorStart: (umlElement: UmlElementProtocol, anchor: ConnectorConnectingSide)?
    @Published var umlConnectorEnd: (umlElement: UmlElementProtocol, anchor: ConnectorConnectingSide)?
    var canvasViewWidth: CGFloat = 0.0
    var canvasViewHeight: CGFloat = 0.0

    // Reposition drag gesture
    private var dragStartLocation: CGPoint?
    private var element: CanvasElementProtocol?

    var canvasOrigin: CGPoint {
        CGPoint(x: canvasSize / 2.0, y: canvasSize / 2.0)
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
}

// MARK: Adding of canvas elements
extension CanvasViewModel {
    func addImageCanvasElement(from image: UIImage) {
        let imageCanvasElement = ImageElement(position: canvasOrigin, image: image)
        canvas.addElement(imageCanvasElement)
    }

    func addPdfCanvasElement(from file: URL) {
        let pdfCanvasElement = PDFElement(position: canvasOrigin, file: file)
        canvas.addElement(pdfCanvasElement)
    }

    func addTextBlock() {
        canvas.addElement(PlainTextElement(position: canvasOrigin))
    }

    func addCodeSnippet() {
        canvas.addElement(CodeElement(position: canvasOrigin))
    }

    func addMarkUpTextBlock(markupType: MarkupElement.MarkupType) {
        canvas.addElement(MarkupElement(position: canvasOrigin, markupType: markupType))
    }

    func storeAnnotation(_ drawing: PKDrawing) {
        annotationCanvas.drawing = drawing
    }

    func addUmlElement(umlElement: UmlElementProtocol) {
        // TODO: Apply factory pattern here
        switch umlElement.umlShape {
        case .diamond:
            canvas.addElement(DiamondUmlElement(position: canvasOrigin))
        case .rectangle:
            canvas.addElement(RectangleUmlElement(position: canvasOrigin))
        }
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

// MARK: Annotation palette controls
extension CanvasViewModel {
    func getAnnotationWidths() -> [CGFloat] {
        AnnotationPalette.annotationWidths
    }

    func getAnnotationColors() -> [UIColor] {
        AnnotationPalette.annotationColors
    }

    func getCurrentTool() -> PKTool {
        annotationPalette.getSelectedTool()
    }
}

// MARK: Annotation palette controls button handlers
extension CanvasViewModel {
    func clearSelectedAnnotationTool() {
        canvasMode = .selection
    }

    func selectPenAnnotationTool() {
        shouldShowAnnotationMenu = canvasMode == .pen
        canvasMode = .pen
        annotationPalette.switchTool(.pen)
    }

    func selectMarkerAnnotationTool() {
        shouldShowAnnotationMenu = canvasMode == .marker
        canvasMode = .marker
        annotationPalette.switchTool(.marker)
    }

    func selectEraserAnnotationTool() {
        canvasMode = .eraser
        annotationPalette.switchTool(.eraser)
    }

    func selectLassoAnnotationTool() {
        canvasMode = .lasso
        annotationPalette.switchTool(.lasso)
    }

    func selectAnnotationWidth(_ width: CGFloat) {
        annotationPalette.setAnnotationWidth(width)
        shouldShowAnnotationMenu = false
    }

    func selectAnnotationColor(_ color: UIColor) {
        annotationPalette.setAnnotationColor(color)
        shouldShowAnnotationMenu = false
    }
}

// MARK: UML side menu controls button handlers
extension CanvasViewModel {
    func showUmlMenu() {
        shouldShowUmlMenu = true
    }

    func hideUmlMenu() {
        shouldShowUmlMenu = false
    }
}

// MARK: UML diagram connector drag gesture
extension CanvasViewModel {
    func getCanvasUmlConnectors() -> [UmlConnector] {
        canvas.umlConnectors
    }

    private func pointInUmlElement(_ point: CGPoint) -> UmlElementProtocol? {
        let canvasElement = canvas.canvasElements.first { $0 is UmlElementProtocol && $0.containsPoint(point) }
        guard let umlElement = canvasElement as? UmlElementProtocol else {
            return nil
        }
        return umlElement
    }

    /// To remove dependency of `OrthogonalConnector` model with `UmlSelectionOverlayView` view
    private func convertToConnectorAnchor(_ anchor: UmlSelectionOverlayView.ConnectorControlAnchor)
    -> ConnectorConnectingSide {
        switch anchor {
        case .middleTop:
            return .middleTop
        case .middleBottom:
            return .middleBottom
        case .middleLeft:
            return .middleLeft
        case .middleRight:
            return .middleRight
        }
    }

    func handleUmlElementDragEnded() {
        guard let element = canvas.getElementBy(id: selectedCanvasElementId) else {
            return
        }
        if element is UmlElementProtocol {
            updateUmlConnections(id: selectedCanvasElementId)
        }
    }

    func handleConnectorTap(_ element: UmlElementProtocol, anchor: UmlSelectionOverlayView.ConnectorControlAnchor) {
        guard let (startUmlElement, startAnchor) = umlConnectorStart else {
            umlConnectorStart = (umlElement: element, anchor: convertToConnectorAnchor(anchor))
            return
        }
        guard  umlConnectorEnd == nil else {
            return
        }
        let newEndAnchor = convertToConnectorAnchor(anchor)
        umlConnectorEnd = (umlElement: element, anchor: newEndAnchor)
        let points = OrthogonalConnector(from: startUmlElement, to: element)
            .generateRoute(startAnchor, destAnchor: newEndAnchor)
        canvas.addUmlConnector(UmlConnector(points: points,
                                            connects: (fromElement: startUmlElement.id,
                                                       toElement: element.id),
                                            connectingSide: (fromSide: startAnchor,
                                                             toSide: newEndAnchor)))
        umlConnectorStart = nil
        umlConnectorEnd = nil
        selectedCanvasElementId = nil
    }

    func updateUmlConnections(id: UUID?) {
        guard let id = id else {
            return
        }
        var idsToRemove: [UUID] = []
        for var connector in canvas.umlConnectors {
            if connector.connects.fromElement != id
                    && connector.connects.toElement != id {
                continue
            }
            idsToRemove.append(connector.id)
            let sourceId = connector.connects.fromElement
            let destId = connector.connects.toElement
            guard let source = canvas.getElementBy(id: sourceId) as? UmlElementProtocol,
                  let dest = canvas.getElementBy(id: destId) as? UmlElementProtocol else {
                return
            }
            let sourceAnchor = connector.connectingSide.fromSide
            let destAnchor = connector.connectingSide.toSide
            let newPoints = OrthogonalConnector(from: source, to: dest)
                .generateRoute(sourceAnchor, destAnchor: destAnchor)
            connector.points = newPoints
            canvas.replaceUmlConnector(connector)
        }
    }
}
