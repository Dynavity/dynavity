import CoreGraphics

struct CodeElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let text: String
    let language: CodeElement.CodeLanguage

    init(model: CodeElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.text = model.text
        self.language = model.language
    }

    func toModel() -> CodeElement {
        let model = CodeElement(position: canvasProperties.position)
        model.canvasProperties = canvasProperties.toModel()
        model.text = text
        model.language = language
        return model
    }
}
