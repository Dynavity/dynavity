import SwiftUI
import PencilKit

struct AnnotationCanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State var annotationCanvasView = PKCanvasWrapperView()
    @State var toolPicker = PKToolPicker()

    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
    }
}

struct AnnotationCanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        AnnotationCanvasView(viewModel: viewModel)
    }
}

extension AnnotationCanvasView {
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: annotationCanvasView)
        toolPicker.addObserver(annotationCanvasView)
        annotationCanvasView.becomeFirstResponder()
    }

    func saveAnnotationToModel() {
        viewModel.storeAnnotation(annotationCanvasView.drawing)
    }

    func didZoom(to scale: CGFloat) {
        viewModel.scaleFactor = scale
    }
}

/// `PKCanvasView` is a `UIKit` view. To use it in SwiftUI,
/// we need to wrap it in a `SwiftUI` view that conforms to UIViewRepresentable.
extension AnnotationCanvasView: UIViewRepresentable {
    func makeUIView(context: Context) -> PKCanvasView {
        // This simulates an "infinite" canvas
        let maxContentSize = CGFloat(500_000)

        // For testing purposes on simulator, not necessary otherwise
        #if targetEnvironment(simulator)
        annotationCanvasView.drawingPolicy = .anyInput
        #endif

        annotationCanvasView.delegate = context.coordinator
        annotationCanvasView.isOpaque = false
        annotationCanvasView.showsVerticalScrollIndicator = false
        annotationCanvasView.showsHorizontalScrollIndicator = false
        annotationCanvasView.contentSize = CGSize(width: maxContentSize, height: maxContentSize)
        annotationCanvasView.minimumZoomScale = CGFloat(0.1)
        annotationCanvasView.maximumZoomScale = CGFloat(2.0)
        annotationCanvasView.bouncesZoom = false

        scrollToInitialContentOffset()
        showToolPicker()
        return annotationCanvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        // Do nothing.
    }

    private func scrollToInitialContentOffset() {
        let centerOffsetX = (annotationCanvasView.contentSize.width - annotationCanvasView.frame.width) / 2
        let centerOffsetY = (annotationCanvasView.contentSize.height - annotationCanvasView.frame.height) / 2
        annotationCanvasView.contentOffset = CGPoint(x: centerOffsetX, y: centerOffsetY)
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
}
