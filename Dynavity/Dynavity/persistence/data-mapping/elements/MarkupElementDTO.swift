import CoreGraphics

struct MarkupElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let text: String
    let markupType: String

    init(model: MarkupElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.text = model.text
        self.markupType = model.markupType.rawValue
    }

    func toModel() -> MarkupElement {
        guard let markupType = MarkupElement.MarkupType(rawValue: self.markupType) else {
            fatalError("Failed to deserialise MarkupType")
        }

        let model = MarkupElement(position: canvasProperties.position, markupType: markupType)
        model.canvasProperties = canvasProperties.toModel()
        model.text = text
        return model
    }
}
