import SwiftUI

class UmlElementViewFactory: ViewFactoryProtocol {
    func createView(element: CanvasElementProtocol) -> some View {
        Group {
            switch element {
            case let activityUmlElement as ActivityUmlElement:
                ActivityUmlElementView(umlElement: activityUmlElement)
            default:
                fatalError("UML view you are trying to create doesn't exist")
            }
        }
    }
}
