import Foundation
import PencilKit

struct AnnotationCanvasDTO: Mappable {
    let id: UUID
    let name: String
    let drawing: PKDrawing

    init(id: UUID, model: IdentifiedAnnotationCanvas) {
        self.id = id
        self.drawing = model.annotationCanvas.drawing
        self.name = model.canvasName
    }

    init(model: IdentifiedAnnotationCanvas) {
        self.init(id: UUID(), model: model)
    }

    func toModel() -> IdentifiedAnnotationCanvas {
        var model = AnnotationCanvas()
        model.drawing = drawing
        return IdentifiedAnnotationCanvas(canvasName: name, annotationCanvas: model)
    }
}

extension AnnotationCanvasDTO: Codable {}
