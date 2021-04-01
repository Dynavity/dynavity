import Foundation
import CoreGraphics

/**
 Encapsulates a connector between two UML shapes.
 */
struct UmlConnector {
    var id = UUID()
    var points: [CGPoint] = []
    // UUID of UmlElementProtocol, actual element is in [CanvasElementProtocol] in Canvas
    var connects: (fromElement: UUID, toElement: UUID)
    var connectingSide: (fromSide: ConnectorConnectingSide, toSide: ConnectorConnectingSide)

    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
}
