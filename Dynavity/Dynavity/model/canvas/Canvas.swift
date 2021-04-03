import Foundation
import CoreGraphics
import FirebaseDatabase
import CodableFirebase

class Canvas: Codable {
    @Published var canvasElements: [CanvasElementProtocol] = []
    @Published var umlConnectors: [UmlConnector] = []
    var name: String = "common"

    private var db: DatabaseReference {
        Database.database().reference().child(name)
    }

    init() {
        // Starting center is now (x: 250000, y:  250000)
//        let testElement1 = TestElement(position: CGPoint(x: 250_000, y: 250_000))
//        let testElement2 = TestElement(position: CGPoint(x: 250_500, y: 250_500))
//        addElement(testElement1)
//        addElement(testElement2)
        db.getData { _, snapshot in
            self.loadSnapshot(snapshot)
        }
        db.observe(.childAdded) { snapshot in
            self.loadSnapshot(snapshot)
        }
    }

    private func loadSnapshot(_ snapshot: DataSnapshot) {
        if let data = snapshot.value,
           let loaded = try? FirebaseDecoder().decode(Canvas.self, from: data) {
            // replace the local snapshot
            self.canvasElements = loaded.canvasElements
            self.umlConnectors = loaded.umlConnectors
        }
    }

    private func saveToDb() {
        let data = try? FirebaseEncoder().encode(self)
        self.db.setValue(data)
    }

    func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
        saveToDb()
    }

    func removeElement(_ element: CanvasElementProtocol) {
        guard let index = canvasElements.firstIndex(where: { $0.id == element.id }) else {
            return
        }

        canvasElements.remove(at: index)
    }

    func replaceElement(_ element: CanvasElementProtocol) {
        guard let index = canvasElements.firstIndex(where: { $0.id == element.id }) else {
            return
        }

        canvasElements[index] = element
    }

    func getElementBy(id: UUID?) -> CanvasElementProtocol? {
        canvasElements.first(where: { $0.id == id })
    }

    func moveCanvasElement(id: UUID?, by translation: CGSize) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].move(by: translation)
    }

    func resizeCanvasElement(id: UUID?, by translation: CGSize) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].resize(by: translation)
    }

    func rotateCanvasElement(id: UUID?, to rotation: Double) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].rotate(to: rotation)
    }

    private enum CodingKeys: String, CodingKey {
        case canvasElements, umlConnectors, name
    }

    required init(from decoder: Decoder) throws {
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

// MARK: UML Connectors
extension Canvas {
    func addUmlConnector(_ connector: UmlConnector) {
        umlConnectors.append(connector)
    }

    func replaceUmlConnector(_ connector: UmlConnector) {
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
