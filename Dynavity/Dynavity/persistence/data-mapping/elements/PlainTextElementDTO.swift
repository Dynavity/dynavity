import CoreGraphics

struct PlainTextElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let text: String

    init(model: PlainTextElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.text = model.text
    }

    func toModel() -> PlainTextElement {
        let model = PlainTextElement(position: canvasProperties.position)
        model.canvasProperties = canvasProperties.toModel()
        model.text = text
        return model
    }
}
