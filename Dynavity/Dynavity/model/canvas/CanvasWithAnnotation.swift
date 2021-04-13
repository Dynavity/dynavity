import Foundation

/**
 Wrapper for Canvas and AnnotationCanvas to be stored together in the persistence layer.
 */
class CanvasWithAnnotation {
    let canvas: Canvas
    let annotationCanvas: AnnotationCanvas
    var name: String

    init(canvas: Canvas, annotationCanvas: AnnotationCanvas) {
        self.canvas = canvas
        self.name = canvas.name
        self.annotationCanvas = annotationCanvas
    }
}

extension CanvasWithAnnotation: Equatable, Hashable {
    // Assumes that names of canvases are unique
    static func == (lhs: CanvasWithAnnotation, rhs: CanvasWithAnnotation) -> Bool {
        lhs.name == rhs.name
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
