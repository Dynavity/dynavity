import CoreGraphics
import Foundation

struct UmlConnectorDTO {
    let points: [CGPoint]
    let connectsFromId: UUID
    let connectsToId: UUID
    let connectingSideFrom: String
    let connectingSideTo: String

    init(
        model: UmlConnector,
        canvasElementDTOs: [TypeWrappedCanvasElementDTO],
        canvasElements: [CanvasElementProtocol]
    ) {
        guard let connectsFromIndex = canvasElements.firstIndex(where: { $0 === model.connects.fromElement }),
              let connectsToIndex = canvasElements.firstIndex(where: { $0 === model.connects.toElement }),
              let connectsFrom = canvasElementDTOs[connectsFromIndex].data as? UmlElementProtocolDTO,
              let connectsTo = canvasElementDTOs[connectsToIndex].data as? UmlElementProtocolDTO else {
            fatalError("Failed to serialise UmlConnector")
        }
        self.points = model.points
        self.connectsFromId = connectsFrom.id
        self.connectsToId = connectsTo.id
        self.connectingSideFrom = model.connectingSide.fromSide.rawValue
        self.connectingSideTo = model.connectingSide.toSide.rawValue
    }

    func toModel(
        canvasElementDTOs: [TypeWrappedCanvasElementDTO],
        canvasElements: [CanvasElementProtocol]
    ) -> UmlConnector {
        guard let connectsFromIndex =
                canvasElementDTOs.firstIndex(where: { connectsFromId == ($0.data as? UmlElementProtocolDTO)?.id }),
              let connectsToIndex =
                canvasElementDTOs.firstIndex(where: { connectsToId == ($0.data as? UmlElementProtocolDTO)?.id }),
              let connectsFrom = canvasElements[connectsFromIndex] as? UmlElementProtocol,
              let connectsTo = canvasElements[connectsToIndex] as? UmlElementProtocol,
              let fromSide = ConnectorConnectingSide(rawValue: connectingSideFrom),
              let toSide = ConnectorConnectingSide(rawValue: connectingSideTo) else {
            fatalError("Failed to deserialise UmlConnector")
        }
        let connectingSide = (fromSide: fromSide, toSide: toSide)
        let connects = (fromElement: connectsFrom, toElement: connectsTo)
        let model = UmlConnector(points: points, connects: connects, connectingSide: connectingSide)
        return model
    }
}

extension UmlConnectorDTO: Codable {}
