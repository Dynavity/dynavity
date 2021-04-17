import CoreGraphics

struct ImageElementDTO: CanvasElementDTOProtocol, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let imageDTO: UIImageDTO

    init(model: ImageElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.imageDTO = UIImageDTO(model: model.image)
    }

    func toModel() -> ImageElement {
        let model = ImageElement(position: canvasProperties.position, image: imageDTO.toModel())
        model.canvasProperties = canvasProperties.toModel()
        return model
    }
}
