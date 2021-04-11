import CoreGraphics

struct UmlConnectorDTO: Mappable {
    var points: [CGPoint]
    var connects: (fromElement: TypeWrappedUmlElementDTO, toElement: TypeWrappedUmlElementDTO)
    var connectingSide: (fromSide: String, toSide: String)

    init(model: UmlConnector) {
        self.points = model.points
        self.connects = (fromElement: TypeWrappedUmlElementDTO(model: model.connects.fromElement),
                         toElement: TypeWrappedUmlElementDTO(model: model.connects.toElement))
        self.connectingSide = (fromSide: model.connectingSide.fromSide.rawValue,
                               toSide: model.connectingSide.toSide.rawValue)
    }

    func toModel() -> UmlConnector {
        guard let fromConnectingSide = ConnectorConnectingSide(rawValue: connectingSide.fromSide),
              let toConnectingSide = ConnectorConnectingSide(rawValue: connectingSide.toSide) else {
            fatalError("Failed to deserialise connector connecting side")
        }
        let model = UmlConnector(points: points,
                                 connects: (fromElement: connects.fromElement.toModel(),
                                            toElement: connects.toElement.toModel()),
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
        let fromElement = try container.decode(TypeWrappedUmlElementDTO.self, forKey: .fromElement)
        let toElement = try container.decode(TypeWrappedUmlElementDTO.self, forKey: .toElement)
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
