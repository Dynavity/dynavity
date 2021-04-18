import Foundation

struct UmlDiagramDTO {
    let elements: [TypeWrappedUmlElementDTO]
    let connectors: [UmlConnectorDTO]

    func toModel() -> (elements: [UmlElementProtocol], connectors: [UmlConnector]) {
        var identifiedUmlElements = [IdentifiedUmlElementWrapper]()
        var elementModels = [UmlElementProtocol]()
        var connectorModels = [UmlConnector]()

        elements.map { $0.toModel() }.forEach {
            identifiedUmlElements.append($0)
            elementModels.append($0.umlElement)
        }
        connectors.map { $0.toModel(umlElements: identifiedUmlElements) }.forEach {
            connectorModels.append($0)
        }
        return (elements: elementModels, connectors: connectorModels)
    }
}

extension UmlDiagramDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case elements, connectors
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.elements = try values.decodeIfPresent([TypeWrappedUmlElementDTO].self, forKey: .elements)
            ?? []
        self.connectors = try values.decodeIfPresent([UmlConnectorDTO].self, forKey: .connectors) ?? []
    }
}
