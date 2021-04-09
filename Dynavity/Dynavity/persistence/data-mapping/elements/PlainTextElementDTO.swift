import CoreGraphics

struct PlainTextElementDTO: CanvasElementProtocolDTO, Mappable {
    typealias Model = PlainTextElement

    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double

    let text: String

    func toModel() -> PlainTextElement {
        let model = PlainTextElement(position: position)
        model.width = width
        model.height = height
        model.rotation = rotation
        model.text = text
        return model
    }
}
