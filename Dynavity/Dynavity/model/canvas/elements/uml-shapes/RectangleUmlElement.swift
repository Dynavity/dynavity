import SwiftUI

struct RectangleUmlElement: UmlElementProtocol {
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 150.0
    var height: CGFloat = 150.0
    var rotation: Double = .zero
    var minimumWidth: CGFloat {
        60.0
    }
    var minimumHeight: CGFloat {
        60.0
    }

    // MARK: UmlElementProtocol
    var label: String = "Process"
    var umlType: UmlType = .activityDiagram
    var umlShape: UmlShape = .rectangle
}
