import CoreGraphics

struct MarkupElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let text: String
    let markupType: MarkupElement.MarkupType

    init(model: MarkupElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.text = model.text
        self.markupType = model.markupType
    }

    func toModel() -> MarkupElement {
        let model = MarkupElement(position: canvasProperties.position, markupType: markupType)
        model.canvasProperties = canvasProperties.toModel()
        model.text = text
        return model
    }
}
