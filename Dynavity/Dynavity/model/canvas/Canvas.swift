import Combine
import Foundation
import CoreGraphics

class Canvas: ObservableObject {
    @Published private(set) var canvasElements: [CanvasElementProtocol] = []
    @Published private(set) var umlConnectors: [UmlConnector] = []
    @Published var annotationCanvas = AnnotationCanvas()

    var name: String = "common"

    var umlElements: [UmlElementProtocol] {
        canvasElements.compactMap { $0 as? UmlElementProtocol }
    }

    private var canvasElementCancellables: [AnyCancellable] = []
    private var umlConnectorCancellables: [AnyCancellable] = []

    init() {}

    init(canvas: Canvas) {
        // The arrays of cancellables cannot be directly copied as they are weak references.
        canvas.canvasElements.forEach(addElement)
        canvas.umlConnectors.forEach(addUmlConnector)

        self.annotationCanvas = canvas.annotationCanvas
        self.name = canvas.name
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

        if let umlElement = element as? UmlElementProtocol {
            removeAttachedConnectors(umlElement)
        }
        canvasElements.remove(at: index)
        canvasElementCancellables.remove(at: index)
    }

    func replace(canvasElements: [CanvasElementProtocol]) {
        self.canvasElements
            .filter { !($0 is UmlElementProtocol) }
            .forEach(removeElement)
        canvasElements.forEach(addElement)
    }

    func replace(annotation: AnnotationCanvas) {
        self.annotationCanvas = annotation
    }

    func replace(umlElements: [UmlElementProtocol], umlConnectors: [UmlConnector]) {
        self.umlConnectors.forEach(removeUmlConnector)
        self.umlElements.forEach(removeElement)
        umlElements.forEach(addElement)
        umlConnectors.forEach(addUmlConnector)
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

    private func removeAttachedConnectors(_ umlElement: UmlElementProtocol) {
        for connector in umlConnectors {
            if connector.connects.fromElement !== umlElement
                    && connector.connects.toElement !== umlElement {
                continue
            }
            removeUmlConnector(connector)
        }
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
