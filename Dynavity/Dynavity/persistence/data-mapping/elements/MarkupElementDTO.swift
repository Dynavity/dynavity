import CoreGraphics

struct MarkupElementDTO: CanvasElementProtocolDTO, Mappable {
    typealias Model = MarkupElement

    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double

    let text: String
    let markupType: MarkupElement.MarkupType

    func toModel() -> MarkupElement {
        let model = MarkupElement(position: position, markupType: markupType)
        model.width = width
        model.height = height
        model.rotation = rotation
        model.text = text
        return model
    }
}
