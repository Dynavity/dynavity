import Foundation

struct OnlineCanvasDTO: Mappable {
    let ownerId: String
    let canvas: CanvasDTO

    init(model: OnlineCanvas) {
        self.ownerId = model.ownerId
        self.canvas = CanvasDTO(id: model.id,
                                model: CanvasWithAnnotation(canvas: model, annotationCanvas: AnnotationCanvas()))
    }

    init(ownerId: String, canvas: CanvasDTO) {
        self.ownerId = ownerId
        self.canvas = canvas
    }

    func toModel() -> OnlineCanvas {
        OnlineCanvas(id: canvas.id, ownerId: ownerId, canvas: canvas.toModel().canvas)
    }
}

extension OnlineCanvasDTO: Codable {}
