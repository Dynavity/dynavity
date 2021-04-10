import SwiftUI
import PencilKit

/**
 Model which stores the `PKDrawing`, representing all the annotations on the `AnnotationCanvasView`.
 The drawing can be stored as a `Data` type for persistence.
 */
struct AnnotationCanvas {
    var drawing = PKDrawing()
}
