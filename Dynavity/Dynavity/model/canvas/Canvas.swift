import Combine
import Foundation
import CoreGraphics

class Canvas: ObservableObject {
    @Published var canvasElements: [CanvasElementProtocol] = []
    @Published private(set) var umlConnectors: [UmlConnector] = []
    var annotationCanvas = AnnotationCanvas()

    var name: String = "common"

    private var canvasElementCancellables: [AnyCancellable] = []
    private var umlConnectorCancellables: [AnyCancellable] = []

    init() {}

    init(canvas: Canvas) {
        self.canvasElements = canvas.canvasElements
        self.umlConnectors = canvas.umlConnectors
        self.annotationCanvas = canvas.annotationCanvas
        self.name = canvas.name
        self.canvasElementCancellables = canvas.canvasElementCancellables
        self.umlConnectorCancellables = canvas.umlConnectorCancellables
    }

    func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
        let cancellable = element.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        canvasElementCancellables.append(cancellable)
    }

    func removeElement(_ element: CanvasElementProtocol) {
        guard let index = canvasElements.firstIndex(where: { $0 === element }) else {
            return
        }

        canvasElements.remove(at: index)
        canvasElementCancellables.remove(at: index)
    }
}

// MARK: UML Connectors
extension Canvas {
    func addUmlConnector(_ connector: UmlConnector) {
        umlConnectors.append(connector)
        let cancellable = connector.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        umlConnectorCancellables.append(cancellable)
    }

    func removeUmlConnector(_ connector: UmlConnector) {
        guard let index = umlConnectors.firstIndex(where: { $0 === connector }) else {
            return
        }
        umlConnectors.remove(at: index)
        umlConnectorCancellables.remove(at: index)
    }
}

extension Canvas: Hashable {
    static func == (lhs: Canvas, rhs: Canvas) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
