import CoreGraphics

struct ActivityUmlElementDTO: Mappable, UmlElementProtocolDTO {
    let canvasProperties: CanvasElementPropertiesDTO

    var label: String
    let umlType: String
    let umlShape: String
    let id: UmlElementId

    init(model: IdentifiedUmlElementWrapper) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.umlElement.canvasProperties)
        self.label = model.umlElement.label
        self.umlType = model.umlElement.umlType.rawValue
        self.umlShape = model.umlElement.umlShape.rawValue
        self.id = model.id
    }

    func toModel() -> IdentifiedUmlElementWrapper {
        guard let unwrappedUmlShape = UmlShape(rawValue: umlShape) else {
            fatalError("Failed to unwrap UML shape or type when mapping DTO to model")
        }
        let model = ActivityUmlElement(position: canvasProperties.position, shape: unwrappedUmlShape)
        model.canvasProperties = canvasProperties.toModel()
        model.label = label
        return IdentifiedUmlElementWrapper(id: id, umlElement: model)
    }
}
