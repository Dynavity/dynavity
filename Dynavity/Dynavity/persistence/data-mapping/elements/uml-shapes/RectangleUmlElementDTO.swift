import Foundation

struct RectangleUmlElementDTO: CanvasElementProtocolDTO, Mappable {
    // For storing UML connectors
    let id: UUID

    let canvasProperties: CanvasElementPropertiesDTO

    let label: String
    let umlType: String
    let umlShape: String

    init(model: RectangleUmlElement) {
        self.id = UUID()
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.label = model.label
        self.umlType = model.umlType.rawValue
        self.umlShape = model.umlShape.rawValue
    }

    func toModel() -> RectangleUmlElement {
        guard let umlType = UmlType(rawValue: self.umlType),
              let umlShape = UmlShape(rawValue: self.umlShape) else {
            fatalError("Failed to deserialise RectangleUmlElement")
        }
        let model = RectangleUmlElement(position: canvasProperties.position)
        model.canvasProperties = canvasProperties.toModel()
        model.label = label
        model.umlType = umlType
        model.umlShape = umlShape
        return model
    }
}
