import CoreGraphics

struct ActivityUmlElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let label: String
    let umlType: String
    let umlShape: String

    init(model: ActivityUmlElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.label = model.label
        self.umlType = model.umlType.rawValue
        self.umlShape = model.umlShape.rawValue
    }

    func toModel() -> ActivityUmlElement {
        guard let unwrappedUmlShape = UmlShape(rawValue: umlShape) else {
            fatalError("Failed to unwrap UML shape or type when mapping DTO to model")
        }
        let model = ActivityUmlElement(position: canvasProperties.position, shape: unwrappedUmlShape)
        model.canvasProperties = canvasProperties.toModel()
        model.label = label
        return model
    }
}
