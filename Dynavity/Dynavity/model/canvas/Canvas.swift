import Foundation
import CoreGraphics

class Canvas: ObservableObject {
    @Published var canvasElements: [CanvasElementProtocol] = []

    init() {
        let canvasElement = TestCanvasElement()
        addElement(canvasElement)
    }

    func addElement(_ element: CanvasElementProtocol) {
        canvasElements.append(element)
    }
}
