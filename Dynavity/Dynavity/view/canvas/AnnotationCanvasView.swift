import SwiftUI
import PencilKit

/**
 Wrapper class for `PKCanvasView` from PencilKit to allow extended functionality with touches inputs.
 */
class AnnotationCanvasView: PKCanvasView {

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // This maintains the inherited functionality of PKCanvasView to do the drawing
        super.touchesBegan(touches, with: event)
        // TODO: Possibly add CanvasElement on user's touch location
    }
}
