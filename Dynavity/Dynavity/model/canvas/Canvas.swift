import Foundation
import CoreGraphics

struct Canvas {
    var canvasElements: [CanvasElementProtocol] = []
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
