import SwiftUI
import PencilKit

// MARK: Annotation palette controls
extension CanvasViewModel {
    func getAnnotationWidths() -> [CGFloat] {
        AnnotationPalette.annotationWidths
    }

    func getAnnotationColors() -> [UIColor] {
        AnnotationPalette.annotationColors
    }

    func getCurrentTool() -> PKTool {
        annotationPalette.getSelectedTool()
    }
}

// MARK: Annotation palette controls button handlers
extension CanvasViewModel {
    func clearSelectedAnnotationTool() {
        canvasMode = .selection
    }

    func selectPenAnnotationTool() {
        shouldShowAnnotationMenu = canvasMode == .pen
        canvasMode = .pen
        annotationPalette.switchTool(.pen)
    }

    func selectMarkerAnnotationTool() {
        shouldShowAnnotationMenu = canvasMode == .marker
        canvasMode = .marker
        annotationPalette.switchTool(.marker)
    }

    func selectEraserAnnotationTool() {
        canvasMode = .eraser
        annotationPalette.switchTool(.eraser)
    }

    func selectLassoAnnotationTool() {
        canvasMode = .lasso
        annotationPalette.switchTool(.lasso)
    }

    func selectAnnotationWidth(_ width: CGFloat) {
        annotationPalette.setAnnotationWidth(width)
        shouldShowAnnotationMenu = false
    }

    func selectAnnotationColor(_ color: UIColor) {
        annotationPalette.setAnnotationColor(color)
        shouldShowAnnotationMenu = false
    }
}

// MARK: AnnotationCanvas functions
extension CanvasViewModel {
    func getAnnotations() -> PKDrawing {
        canvas.annotationCanvas.drawing
    }
}
