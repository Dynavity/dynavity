import Foundation

struct DiamondUmlElementDTO: UmlElementProtocolDTO, Mappable {
    // For storing UML connectors
    let id: UUID

    let canvasProperties: CanvasElementPropertiesDTO

    let label: String
    let umlType: String
    let umlShape: String

    init(model: DiamondUmlElement) {
        self.id = UUID()
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.label = model.label
        self.umlType = model.umlType.rawValue
        self.umlShape = model.umlShape.rawValue
    }

    func toModel() -> DiamondUmlElement {
        guard let umlType = UmlType(rawValue: self.umlType),
              let umlShape = UmlShape(rawValue: self.umlShape) else {
            fatalError("Failed to deserialise DiamondUmlElement")
        }
        let model = DiamondUmlElement(position: canvasProperties.position)
        model.canvasProperties = canvasProperties.toModel()
        model.label = label
        model.umlType = umlType
        model.umlShape = umlShape
        return model
    }
}
