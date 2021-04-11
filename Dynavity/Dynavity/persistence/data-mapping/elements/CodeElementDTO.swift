import CoreGraphics

struct CodeElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let text: String
    let language: String

    init(model: CodeElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.text = model.text
        self.language = model.language.rawValue
    }

    func toModel() -> CodeElement {
        guard let language = CodeElement.CodeLanguage(rawValue: self.language) else {
            fatalError("Failed to deserialise CodeLanguage")
        }
        let model = CodeElement(position: canvasProperties.position)
        model.canvasProperties = canvasProperties.toModel()
        // Note: language must be set before text since setting language triggers a template reset
        model.language = language
        model.text = text
        return model
    }
}
