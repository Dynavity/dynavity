import Foundation

struct OnlineCanvasDTO: Mappable {
    let id: UUID
    let ownerId: String
    let canvas: CanvasDTO

    init(model: OnlineCanvas) {
        self.id = model.id
        self.ownerId = model.ownerId
        self.canvas = CanvasDTO(id: model.id,
                                model: CanvasWithAnnotation(canvas: model, annotationCanvas: AnnotationCanvas()))
    }

    func toModel() -> OnlineCanvas {
        OnlineCanvas(id: id, ownerId: ownerId, canvas: canvas.toModel().canvas)
    }
}

extension OnlineCanvasDTO: Codable {}
