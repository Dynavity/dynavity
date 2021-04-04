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
    var observers = [ElementChangeListener]()

    // MARK: UmlElementProtocol
    var label: String = "Process" {
        didSet { notifyObservers() }
    }
    var umlType: UmlType = .activityDiagram
    var umlShape: UmlShape = .rectangle
}

extension RectangleUmlElement: Codable {
    private enum CodingKeys: CodingKey {
        case id, position, width, height, rotation, label, umlType, umlShape
    }
}
