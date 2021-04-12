import Foundation

struct OnlineCanvasDTO: Mappable {
    let ownerId: String
    let canvas: CanvasDTO

    init(ownerId: String, canvas: CanvasDTO) {
        self.ownerId = ownerId
        self.canvas = canvas
    }

    init(model: OnlineCanvas) {
        self.ownerId = model.ownerId
        self.canvas = CanvasDTO(model: CanvasWithAnnotation(canvas: model, annotationCanvas: AnnotationCanvas()))
    }

    func toModel() -> OnlineCanvas {
        OnlineCanvas(ownerId: ownerId, canvas: canvas.toModel().canvas)
    }
}
