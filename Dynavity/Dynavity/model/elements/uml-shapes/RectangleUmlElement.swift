import Combine
import SwiftUI

class RectangleUmlElement: ObservableObject, CanvasElementProtocol, UmlElementProtocol {
    // MARK: CanvasElementProtocol
    @Published var canvasProperties: CanvasElementProperties

    // MARK: UmlElementProtocol
    var label: String
    var umlType: UmlType
    var umlShape: UmlShape

    init(position: CGPoint) {
        self.canvasProperties = CanvasElementProperties(
            position: position,
            width: 150.0,
            height: 150.0,
            minimumWidth: 60.0,
            minimumHeight: 60.0
        )
        self.label = "Process"
        self.umlType = .activityDiagram
        self.umlShape = .rectangle
    }
}
