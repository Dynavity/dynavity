import Foundation

/**
 Wrapper for Canvas and AnnotationCanvas to be stored together in the persistence layer.
 */
class CanvasWithAnnotation {
    let canvas: Canvas
    // Remove dependency of storage with PencilKit
    let annotationCanvas: Data
    var name: String

    init(canvas: Canvas, annotationCanvas: Data) {
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
        hasher.combine(ObjectIdentifier(self).hashValue)
    }
}
