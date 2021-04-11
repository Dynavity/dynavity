import CoreGraphics

struct UmlConnectorDTO: Mappable {
    var points: [CGPoint]
    var connects: (fromElement: UmlElementId, toElement: UmlElementId)
    var connectingSide: (fromSide: String, toSide: String)

    static func generateIdFromReference(umlElement: UmlElementProtocol) -> UmlElementId {
        UmlElementId(id: ObjectIdentifier(umlElement).hashValue)
    }

    init(model: UmlConnector) {
        self.points = model.points
        let fromId = UmlConnectorDTO.generateIdFromReference(umlElement: model.connects.fromElement)
        let toId = UmlConnectorDTO.generateIdFromReference(umlElement: model.connects.toElement)
        self.connects = (fromElement: fromId,
                         toElement: toId)
        self.connectingSide = (fromSide: model.connectingSide.fromSide.rawValue,
                               toSide: model.connectingSide.toSide.rawValue)
    }

    func toModel(umlElements: [IdentifiedUmlElementWrapper]) -> UmlConnector {
        guard let fromConnectingSide = ConnectorConnectingSide(rawValue: connectingSide.fromSide),
              let toConnectingSide = ConnectorConnectingSide(rawValue: connectingSide.toSide) else {
            fatalError("Failed to deserialise connector connecting side")
        }
        let fromElement = umlElements.first { $0.id == connects.fromElement }
        let toElement = umlElements.first { $0.id == connects.toElement }

        guard let from = fromElement?.umlElement,
              let to = toElement?.umlElement else {
            fatalError("Failed to get connecting uml elements")
        }
        let model = UmlConnector(points: points,
                                 connects: (fromElement: from,
                                            toElement: to),
                                 connectingSide: (fromSide: fromConnectingSide,
                                                  toSide: toConnectingSide))
        return model
    }
}

extension UmlConnectorDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case points, fromElement, toElement, fromSide, toSide
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.points = try container.decode([CGPoint].self, forKey: .points)
        let fromElement = try container.decode(UmlElementId.self, forKey: .fromElement)
        let toElement = try container.decode(UmlElementId.self, forKey: .toElement)
        self.connects = (fromElement: fromElement, toElement: toElement)
        let fromSide = try container.decode(String.self, forKey: .fromSide)
        let toSide = try container.decode(String.self, forKey: .toSide)
        self.connectingSide = (fromSide: fromSide,
                               toSide: toSide)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(points, forKey: .points)
        try container.encode(connects.fromElement, forKey: .fromElement)
        try container.encode(connects.toElement, forKey: .toElement)
        try container.encode(connectingSide.fromSide, forKey: .fromSide)
        try container.encode(connectingSide.toSide, forKey: .toSide)
    }

}

extension UmlConnectorDTO {
    // swiftlint:disable unavailable_function
    func toModel() -> UmlConnector {
        fatalError("Should use overloaded toModel function for UmlConnectorDTO")
    }
}
