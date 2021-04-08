import CoreGraphics

struct ImageElementDTO: CanvasElementProtocolDTO, Mappable {
    typealias T = ImageElement

    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double

    let imageDTO: UIImageDTO

    func toModel() -> ImageElement {
        let model = ImageElement(position: position, image: imageDTO.toModel())
        model.width = width
        model.height = height
        model.rotation = rotation
        return model
    }
}
