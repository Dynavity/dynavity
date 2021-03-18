import Foundation
import CoreGraphics

struct Canvas {
    var canvasElements: [CanvasElementProtocol] = []

    init() {
        let testElement1 = TestCanvasElement(position: CGPoint(x: -150, y: -150), text: "Test1")
        let testElement2 = TestCanvasElement(position: CGPoint(x: 150, y: 150), text: "Test2")
        addElement(testElement1)
        addElement(testElement2)
    }

    mutating func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
    }
}
