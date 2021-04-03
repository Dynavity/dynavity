import Foundation
import CoreGraphics

struct Canvas: Codable {
    var canvasElements: [CanvasElementProtocol] = []
    var umlConnectors: [UmlConnector] = []
    var name: String = ""

    init() {
        /// Starting center is now (x: 250000, y:  250000)
        let testElement1 = TestElement(position: CGPoint(x: 250_000, y: 250_000))
        let testElement2 = TestElement(position: CGPoint(x: 250_500, y: 250_500))
        addElement(testElement1)
        addElement(testElement2)
    }

    mutating func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
    }

    mutating func removeElement(_ element: CanvasElementProtocol) {
        guard let index = canvasElements.firstIndex(where: { $0.id == element.id }) else {
            return
        }

        canvasElements.remove(at: index)
    }

    mutating func replaceElement(_ element: CanvasElementProtocol) {
        guard let index = canvasElements.firstIndex(where: { $0.id == element.id }) else {
            return
        }

        canvasElements[index] = element
    }

    func getElementBy(id: UUID?) -> CanvasElementProtocol? {
        canvasElements.first(where: { $0.id == id })
    }

    mutating func moveCanvasElement(id: UUID?, by translation: CGSize) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].move(by: translation)
    }

    mutating func resizeCanvasElement(id: UUID?, by translation: CGSize) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].resize(by: translation)
    }

    mutating func rotateCanvasElement(id: UUID?, to rotation: Double) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].rotate(to: rotation)
    }

    private enum CodingKeys: String, CodingKey {
        case canvasElements, umlConnectors, name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrappedElements = try container.decode([TypeWrappedCanvasElement].self, forKey: .canvasElements)
        self.canvasElements = wrappedElements.map { $0.data }
        self.umlConnectors = try container.decode([UmlConnector].self, forKey: .umlConnectors)
        self.name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let wrappedElements = canvasElements.map(TypeWrappedCanvasElement.init)
        try container.encode(wrappedElements, forKey: .canvasElements)
        try container.encode(self.umlConnectors, forKey: .umlConnectors)
        try container.encode(self.name, forKey: .name)
    }
}

// MARK: UML Connectors
extension Canvas {
    mutating func addUmlConnector(_ connector: UmlConnector) {
        umlConnectors.append(connector)
    }

    mutating func replaceUmlConnector(_ connector: UmlConnector) {
        guard let index = umlConnectors.firstIndex(where: { $0.id == connector.id }) else {
            return
        }

        umlConnectors[index] = connector
    }

    mutating func removeUmlConnector(_ connector: UmlConnector) {
        guard let index = umlConnectors.firstIndex(where: { $0.id == connector.id }) else {
            return
        }

        umlConnectors.remove(at: index)
    }
}
