import Combine
import Foundation
import CoreGraphics

class Canvas: ObservableObject {
    @Published private(set) var canvasElements: [CanvasElementProtocol] = []
    @Published private(set) var umlConnectors: [UmlConnector] = []
    var name: String = "common"
    private var canvasElementCancellables: [AnyCancellable] = []
    private var umlConnectorCancellables: [AnyCancellable] = []

    init() {}

    init(canvas: Canvas) {
        self.canvasElements = canvas.canvasElements
        self.umlConnectors = canvas.umlConnectors
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

/* TODO: Fix this. (or remove this)
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
            .map(TypeWrappedCanvasElement.init)
        try container.encode(wrappedElements, forKey: .canvasElements)
        try container.encode(self.umlConnectors, forKey: .umlConnectors)
        try container.encode(self.name, forKey: .name)
    }
}
*/

extension Canvas: Hashable {
    static func == (lhs: Canvas, rhs: Canvas) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
