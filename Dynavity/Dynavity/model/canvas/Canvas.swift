import Foundation
import CoreGraphics

struct Canvas {
    var canvasElements: [CanvasElementProtocol] = []
    var umlConnectors: [UmlConnector] = []
    var name: String = "common"

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

extension Canvas: Codable {
    private enum CodingKeys: String, CodingKey {
        case canvasElements, umlConnectors, name
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        func getOrDefault<T: Decodable>(type: T.Type, key: CodingKeys, orElse: T) -> T {
            (try? container.decode(type, forKey: key)) ?? orElse
        }
        let wrappedElements = getOrDefault(type: [TypeWrappedCanvasElement].self,
                                           key: .canvasElements,
                                           orElse: [])
        self.canvasElements = wrappedElements.map { $0.data }
        self.umlConnectors = getOrDefault(type: [UmlConnector].self,
                                          key: .umlConnectors,
                                          orElse: [])
        self.name = try container.decode(String.self, forKey: .name)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let wrappedElements = canvasElements
            .filter { !($0 is TestElement) } // TODO remove when testelements are gone
            .map(TypeWrappedCanvasElement.init)
        try container.encode(wrappedElements, forKey: .canvasElements)
        try container.encode(self.umlConnectors, forKey: .umlConnectors)
        try container.encode(self.name, forKey: .name)
    }
}
