import Combine
import SwiftUI
import PDFKit
import PencilKit
import FirebaseDatabase
import CodableFirebase

class CanvasViewModel: ObservableObject {
    private static let autoSaveInterval = 3.0

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

    // to prevent an infinite loop of didSet when loading changes
    private var enableWriteBack = true
    @Published var canvas: Canvas {
        didSet {
            if enableWriteBack {
                // Prevent the saving to Firebase operation from freezing the main thread.
                DispatchQueue.global(qos: .userInteractive).async {
                    self.saveToFirebase()
                }
            }
        }
    }
    private var anyCancellable: AnyCancellable?
    @Published var annotationCanvas = AnnotationCanvas()
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

    init(canvas: Canvas, canvasSize: CGFloat) {
        self.canvas = canvas
        self.canvasSize = canvasSize
        self.canvasMode = .pen
        self.anyCancellable = canvas.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        loadFromFirebase()
    }

    convenience init(canvas: Canvas) {
        // Arbitrarily large value for the "infinite" canvas.
        self.init(canvas: canvas, canvasSize: 500_000)
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
        self.canvasRepo.save(model: self.canvas)
    }
}

// MARK: Firebase synchronization
extension CanvasViewModel {
    private var db: DatabaseReference {
        Database.database().reference(withPath: canvas.name)
    }

    private func loadFromFirebase() {
        db.getData { _, snapshot in
            self.loadSnapshot(snapshot)
        }
        db.observe(.value, with: loadSnapshot)
    }

    private func loadSnapshot(_ snapshot: DataSnapshot) {
        /* TODO: Fix this.
        if let data = snapshot.value,
           let loadedCanvas = try? FirebaseDecoder().decode(Canvas.self, from: data) {
            // replace the local snapshot
            DispatchQueue.main.async {
                self.enableWriteBack = false
                // Do not update the currently selected canvas element.
                // TODO: Fix this for classes.
                // if let selectedCanvasElement = self.selectedCanvasElement {
                //     loadedCanvas.replaceElement(selectedCanvasElement)
                // }
                self.canvas = loadedCanvas
                self.enableWriteBack = true
            }
        }
        */
    }

    private func saveToFirebase() {
        /* TODO: Fix this.
        let data = try? FirebaseEncoder().encode(canvas)
        db.setValue(data)
        */
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

    private func resizeSelectedCanvasElement(by translation: CGSize, anchor: SelectionOverlayView.ResizeControlAnchor) {
        // TODO: Look into simplifying this now that we use classes.
        guard let element = element,
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
