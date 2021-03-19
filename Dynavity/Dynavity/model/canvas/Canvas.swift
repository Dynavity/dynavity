import Foundation
import CoreGraphics

struct Canvas {
    var canvasElements: [CanvasElementProtocol] = []
    var name: String = ""

    init() {
        /// Starting center is now (x: 250000, y:  250000) 
        let testElement1 = TestCanvasElement(position: CGPoint(x: 250_000, y: 250_000), text: "Test1")
        let testElement2 = TestCanvasElement(position: CGPoint(x: 250_500, y: 250_500), text: "Test2")
        addElement(testElement1)
        addElement(testElement2)
    }

    mutating func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
    }
}
