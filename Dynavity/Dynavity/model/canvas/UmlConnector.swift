import Foundation
import CoreGraphics
import Combine

/**
 Encapsulates a connector between two UML shapes.
 */
class UmlConnector: Identifiable, AnyObservableObject {
    var objectWillChange: ObservableObjectPublisher

    var points: [CGPoint]
    var connects: (fromElement: UmlElementProtocol, toElement: UmlElementProtocol)
    var connectingSide: (fromSide: ConnectorConnectingSide, toSide: ConnectorConnectingSide)

    init(points: [CGPoint],
         connects: (fromElement: UmlElementProtocol, toElement: UmlElementProtocol),
         connectingSide: (fromSide: ConnectorConnectingSide, toSide: ConnectorConnectingSide)) {
        self.points = points
        self.connects = connects
        self.connectingSide = connectingSide
        self.objectWillChange = ObservableObjectPublisher()
    }

    func addPoint(_ point: CGPoint) {
        points.append(point)
    }
}
