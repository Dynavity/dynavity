import Foundation
import CoreGraphics

struct Canvas {
    var canvasElements: [CanvasElementProtocol] = []
    var name: String = ""

    init() {
        let testElement1 = TestCanvasElement(position: CGPoint(x: -150, y: -150), text: "Test1")
        let testElement2 = TestCanvasElement(position: CGPoint(x: 150, y: 150), text: "Test2")
        addElement(testElement1)
        addElement(testElement2)
    }

    mutating func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
    }

    func repositionCanvasElement(id: UUID?, to location: CGPoint) {
        guard let index = canvasElements.firstIndex(where: { $0.id == id }) else {
            return
        }

        canvasElements[index].position = location
    }
}
