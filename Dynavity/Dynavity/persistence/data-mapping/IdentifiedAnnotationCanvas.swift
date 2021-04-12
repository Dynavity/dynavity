import Foundation

class IdentifiedAnnotationCanvas {
    var canvasName: String
    var annotationCanvas: AnnotationCanvas

    init(canvasName: String, annotationCanvas: AnnotationCanvas) {
        self.canvasName = canvasName
        self.annotationCanvas = annotationCanvas
    }
}
