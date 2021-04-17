import Combine
import SwiftUI
import PDFKit
import PencilKit
import FirebaseDatabase
import CodableFirebase

class CanvasViewModel: ObservableObject {
    private static let autoSaveInterval = 10.0
    // Arbitrarily large value for the "infinite" canvas.
    private static let canvasSize: CGFloat = 500_000

    enum CanvasMode {
        case selection
        case pen
        case marker
        case eraser
        case lasso
    }

    private let canvasRepo = CanvasRepository()

    // We are not interested in the return value of each publisher,
    // that's why the values are mapped away
    let autoSavePublisher = Publishers.Merge(
        // Publishes whenever app loses focus
        NotificationCenter.default
            .publisher(for: UIApplication.willResignActiveNotification)
            .map({ _ in () }),
        // Publishes at fixed time intervals
        Timer.publish(every: CanvasViewModel.autoSaveInterval, on: .main, in: .default)
            .autoconnect()
            .map({ _ in () })
    )

    @Published var canvas: Canvas
    private var anyCancellable: AnyCancellable?
    @Published var annotationPalette = AnnotationPalette()
    @Published var canvasSize: CGFloat
    @Published var canvasTopLeftOffset: CGPoint = .zero
    @Published var scaleFactor: CGFloat = 1.0
    @Published var selectedCanvasElement: CanvasElementProtocol? {
        didSet {
            if selectedCanvasElement != nil {
                selectedUmlConnector = nil
            }
        }
    }
    @Published var canvasMode: CanvasMode {
        didSet {
            // Reset canvas element selection on selecting some other mode.
            if oldValue == .selection && canvasMode != oldValue {
                selectedCanvasElement = nil
            }
            // Reset annotation menu on changing mode.
            if oldValue != canvasMode {
                shouldShowAnnotationMenu = false
            }
        }
    }
    @Published var shouldShowAnnotationMenu = false
    @Published var shouldShowUmlMenu = false

    // Uml element connectors
    @Published var selectedUmlConnector: UmlConnector? {
        didSet {
            if selectedUmlConnector != nil {
                selectedCanvasElement = nil
            }
        }
    }
    @Published var umlConnectorStart: (umlElement: UmlElementProtocol, anchor: ConnectorConnectingSide)?
    @Published var umlConnectorEnd: (umlElement: UmlElementProtocol, anchor: ConnectorConnectingSide)?
    var canvasViewport: CGSize = .zero

    // Reposition drag gesture
    private var dragStartLocation: CGPoint?
    // Store a copy of the original canvas element properties for resizing calculations
    private var elementProperties: CanvasElementProperties?

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

    init(canvas: Canvas, canvasSize: CGFloat) {
        self.canvas = canvas
        self.canvasSize = canvasSize
        self.canvasMode = .selection
        self.anyCancellable = canvas.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    convenience init(canvas: Canvas) {
        self.init(canvas: canvas, canvasSize: CanvasViewModel.canvasSize)
    }

    convenience init() {
        self.init(canvas: Canvas())
    }

    var canvasElements: [CanvasElementProtocol] {
        canvas.canvasElements
    }

    func setCanvasViewport(size: CGSize) {
        canvasViewport = size
    }
}

// MARK: Local storage autosaving
extension CanvasViewModel {
    func saveCanvas() {
        self.canvasRepo.save(model: canvas)
        self.objectWillChange.send()
    }
}

// MARK: Firebase synchronization
extension CanvasViewModel {
    func publishCanvas() {
        guard !(canvas is OnlineCanvas) else {
            // if already published, ignore
            return
        }
        canvasRepo.delete(model: canvas)
        canvas = OnlineCanvas(canvas: canvas)
        canvasRepo.save(model: canvas)
        self.objectWillChange.send()
    }
}

// MARK: Adding of canvas elements
extension CanvasViewModel {
    func addImageElement(from image: UIImage) {
        let imageCanvasElement = ImageElement(position: canvasCenter, image: image)
        canvas.addElement(imageCanvasElement)
    }

    func addPdfElement(from file: URL) {
        guard let pdfDocument = PDFDocument(url: file) else {
            return
        }
        let pdfCanvasElement = PDFElement(position: canvasCenter, pdfDocument: pdfDocument)
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
        canvas.annotationCanvas.drawing = drawing
    }

    func addUmlElement(umlElement: UmlElementProtocol) {
        switch umlElement.umlType {
        case .activityDiagram:
            canvas.addElement(ActivityUmlElement(position: canvasCenter, shape: umlElement.umlShape))
        }
    }
}

// MARK: Editing/deleting of canvas elements
extension CanvasViewModel {
    func select(canvasElement: CanvasElementProtocol) {
        if selectedCanvasElement === canvasElement {
            unselectCanvasElement()
            return
        }
        selectedCanvasElement = canvasElement
    }

    func unselectCanvasElement() {
        selectedCanvasElement = nil
        umlConnectorStart = nil
    }

    func moveSelectedCanvasElement(by translation: CGSize) {
        guard let element = selectedCanvasElement else {
            return
        }

        let rotation = element.rotation
        let rotatedTranslation = translation.rotate(by: CGFloat(rotation))
        element.move(by: rotatedTranslation)
    }

    private func resizeSelectedCanvasElement(to translation: CGSize, anchor: SelectionOverlayView.ResizeControlAnchor) {
        guard var elementProperties = elementProperties,
              let originalElementProperties = self.elementProperties else {
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
        elementProperties.resize(by: resizeTranslation)

        var clampedTranslation = translation
        // Clamp x-axis if necessary.
        if elementProperties.width == elementProperties.minimumWidth {
            let actualWidth = originalElementProperties.width + resizeTranslation.width
            let widthDelta = elementProperties.minimumWidth - actualWidth
            if anchor == .topLeftCorner || anchor == .bottomLeftCorner {
                clampedTranslation.width -= widthDelta
            } else {
                clampedTranslation.width += widthDelta
            }
        }
        // Clamp y-axis if necessary.
        if elementProperties.height == elementProperties.minimumHeight {
            let actualHeight = originalElementProperties.height + resizeTranslation.height
            let heightDelta = elementProperties.minimumHeight - actualHeight
            if anchor == .topLeftCorner || anchor == .topRightCorner {
                clampedTranslation.height -= heightDelta
            } else {
                clampedTranslation.height += heightDelta
            }
        }

        let rotation = elementProperties.rotation
        let centerTranslation = clampedTranslation.rotate(by: CGFloat(rotation)) / 2.0
        elementProperties.move(by: centerTranslation)

        selectedCanvasElement?.canvasProperties = elementProperties
    }

    func rotateSelectedCanvasElement(by translation: CGSize) {
        // Prevent excessive spinning when dragging near the center of the canvas element.
        let deadZone: CGFloat = 15.0
        guard abs(translation.height) > deadZone else {
            return
        }

        guard let element = selectedCanvasElement else {
            return
        }

        let currentRotation = element.rotation
        let rotatedTranslation = translation.rotate(by: CGFloat(currentRotation))

        // Transform the rotation angle from the x-axis to the y-axis.
        let rotationOffset = Double.pi / 2.0
        let rotation = Double(atan2(rotatedTranslation.height, rotatedTranslation.width)) + rotationOffset

        element.rotate(to: rotation)
    }

    func removeElement(_ element: CanvasElementProtocol) {
        canvas.removeElement(element)
    }
}

// MARK: Reposition drag gesture
extension CanvasViewModel {
    func handleDragChange(_ value: DragGesture.Value, anchor: SelectionOverlayView.ResizeControlAnchor) {
        if dragStartLocation == nil {
            guard let element = selectedCanvasElement else {
                return
            }
            dragStartLocation = value.startLocation
            self.elementProperties = element.canvasProperties
        }

        guard let dragStartLocation = dragStartLocation,
              let elementProperties = elementProperties else {
            return
        }

        let translation: CGSize = (value.location - dragStartLocation) / scaleFactor
        let rotatedTranslation = translation.rotate(by: -CGFloat(elementProperties.rotation))
        resizeSelectedCanvasElement(to: rotatedTranslation, anchor: anchor)
    }

    func handleDragEnd() {
        dragStartLocation = nil
        elementProperties = nil
    }
}
