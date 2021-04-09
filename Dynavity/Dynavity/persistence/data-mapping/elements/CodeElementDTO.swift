import CoreGraphics

struct CodeElementDTO: CanvasElementProtocolDTO, Mappable {
    typealias Model = CodeElement

    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double

    let text: String
    let language: CodeElement.CodeLanguage

    func toModel() -> CodeElement {
        let model = CodeElement(position: position)
        model.width = width
        model.height = height
        model.rotation = rotation
        model.text = text
        model.language = language
        return model
    }
}
