import SwiftUI
import PencilKit

struct AnnotationCanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State private var annotationCanvasView = PKCanvasWrapperView()
    private let isDrawingDisabled: Bool

    private var shouldUpdateViewport: Bool {
        isDrawingDisabled && viewModel.canvasMode != .selection
            || !isDrawingDisabled && viewModel.canvasMode == .selection
    }

    init(viewModel: CanvasViewModel, isDrawingDisabled: Bool) {
        self.viewModel = viewModel
        self.isDrawingDisabled = isDrawingDisabled
    }

    init(viewModel: CanvasViewModel) {
        self.init(viewModel: viewModel, isDrawingDisabled: false)
    }
}

struct AnnotationCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        AnnotationCanvasView(viewModel: viewModel)
    }
}

extension AnnotationCanvasView {
    func saveAnnotationToModel() {
        viewModel.storeAnnotation(annotationCanvasView.drawing)
    }

    func didZoom(to scale: CGFloat) {
        if !shouldUpdateViewport {
            viewModel.scaleFactor = scale
        }
    }

    func didScroll(to offset: CGPoint) {
        if !shouldUpdateViewport {
            viewModel.canvasTopLeftOffset = offset
        }
    }
}

/// `PKCanvasView` is a `UIKit` view. To use it in SwiftUI,
/// we need to wrap it in a `SwiftUI` view that conforms to UIViewRepresentable.
extension AnnotationCanvasView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        // For testing purposes on simulator, not necessary otherwise
        #if targetEnvironment(simulator)
        annotationCanvasView.drawingPolicy = .anyInput
        #endif

        annotationCanvasView.drawingPolicy = .anyInput
        annotationCanvasView.delegate = context.coordinator
        annotationCanvasView.isOpaque = false
        annotationCanvasView.showsVerticalScrollIndicator = false
        annotationCanvasView.showsHorizontalScrollIndicator = false
        annotationCanvasView.contentSize = CGSize(
            width: viewModel.canvasSize,
            height: viewModel.canvasSize
        )
        annotationCanvasView.minimumZoomScale = CGFloat(0.1)
        annotationCanvasView.maximumZoomScale = CGFloat(2.0)
        annotationCanvasView.bouncesZoom = false
        annotationCanvasView.contentOffset = viewModel.canvasOrigin
        annotationCanvasView.scrollsToTop = false
        annotationCanvasView.drawing = viewModel.getAnnotations()
        return annotationCanvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        if shouldUpdateViewport {
            annotationCanvasView.zoomScale = viewModel.scaleFactor
            annotationCanvasView.contentOffset = viewModel.canvasTopLeftOffset
        }

        // Disable drawing by setting the tool to the eraser.
        if isDrawingDisabled {
            annotationCanvasView.tool = PKEraserTool(.vector)
            return
        }

        // Update annotation tool
        annotationCanvasView.tool = viewModel.getCurrentTool()
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(canvasView: self,
                    onChange: saveAnnotationToModel)
    }
}

class Coordinator: NSObject {
    var annotationCanvasView: AnnotationCanvasView
    let onChange: () -> Void

    init(canvasView: AnnotationCanvasView,
         onChange: @escaping () -> Void) {
        self.annotationCanvasView = canvasView
        self.onChange = onChange
    }
}

extension Coordinator: PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        if !canvasView.drawing.bounds.isEmpty {
            onChange()
        }
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        annotationCanvasView.didZoom(to: scrollView.zoomScale)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        annotationCanvasView.didScroll(to: scrollView.contentOffset)
    }
}
