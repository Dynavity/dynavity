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

/* TODO: Fix this.
extension UmlConnector: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, points, fromElement, toElement, fromSide, toSide
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.points = try container.decode([CGPoint].self, forKey: .points)
        let fromElement = try container.decode(UUID.self, forKey: .fromElement)
        let toElement = try container.decode(UUID.self, forKey: .toElement)
        self.connects = (fromElement: fromElement, toElement: toElement)
        let fromSide = try container.decode(ConnectorConnectingSide.self, forKey: .fromSide)
        let toSide = try container.decode(ConnectorConnectingSide.self, forKey: .toSide)
        self.connectingSide = (fromSide: fromSide, toSide: toSide)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(points, forKey: .points)
        try container.encode(connects.fromElement, forKey: .fromElement)
        try container.encode(connects.toElement, forKey: .toElement)
        try container.encode(connectingSide.fromSide, forKey: .fromSide)
        try container.encode(connectingSide.toSide, forKey: .toSide)
    }
}
*/
