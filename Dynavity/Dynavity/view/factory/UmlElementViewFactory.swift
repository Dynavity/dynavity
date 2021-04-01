import SwiftUI

class UmlElementViewFactory: ViewFactory {
    func createView(element: CanvasElementProtocol) -> some View {
        Group {
            switch element {
            case let diamondUmlElement as DiamondUmlElement:
                DiamondUmlView(umlElement: diamondUmlElement)
            case let rectangleUmlElement as RectangleUmlElement:
                RectangleUmlView(umlElement: rectangleUmlElement)
            default:
                fatalError("UML view you are trying to create doesn't exist")
            }
        }
    }
}
