import CoreGraphics

struct CanvasElementPropertiesDTO: Mappable {
    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double
    let minimumWidth: CGFloat
    let minimumHeight: CGFloat

    init(model: CanvasElementProperties) {
        self.position = model.position
        self.width = model.width
        self.height = model.height
        self.rotation = model.rotation
        self.minimumWidth = model.minimumWidth
        self.minimumHeight = model.minimumHeight
    }

    func toModel() -> CanvasElementProperties {
        CanvasElementProperties(position: position, width: width,
                                height: height, rotation: rotation,
                                minimumWidth: minimumHeight, minimumHeight: minimumHeight)
    }
}

extension CanvasElementPropertiesDTO: Codable {}
