import SwiftUI
import PencilKit

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @State var annotationCanvasView = AnnotationCanvasView()
    @State var toolPicker = PKToolPicker()

    // For zoom interactions
    @State var zoomScale = CGFloat(1.0)

    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        CanvasView(viewModel: viewModel)
    }
}

extension CanvasView {
    func showToolPicker() {
        toolPicker.setVisible(true, forFirstResponder: annotationCanvasView)
        toolPicker.addObserver(annotationCanvasView)
        annotationCanvasView.becomeFirstResponder()
    }

    func saveAnnotationToModel() {
        viewModel.storeAnnotation(annotationCanvasView.drawing)
    }

    func didZoom(to scale: CGFloat) {
        zoomScale = scale
        cleanAnnotationCanvasView()
        populateAnnotationCanvasView()
    }
}

/// `PKCanvasView` is a `UIKit` view. To use it in SwiftUI,
/// we need to wrap it in a `SwiftUI` view that conforms to UIViewRepresentable.
extension CanvasView: UIViewRepresentable {
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

        scrollToInitialContentOffset()
        showToolPicker()
        return annotationCanvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        cleanAnnotationCanvasView()
        populateAnnotationCanvasView()
    }

    private func cleanAnnotationCanvasView() {
        annotationCanvasView.subviews.forEach {
            if $0.accessibilityLabel == "CanvasElements" {
                $0.removeFromSuperview()
            }
        }
    }

    private func populateAnnotationCanvasView() {
        let canvasElementMapView = CanvasElementMapView(elements: $viewModel.canvas.canvasElements)
            .scaleEffect(zoomScale)
        let canvasElements = UIHostingController(rootView: canvasElementMapView)

        /// To remove on only canvasElements when cleaning, other `UIView`s are necessary for `PKCanvasView` to draw
        canvasElements.view.accessibilityLabel = "CanvasElements"

        /// Draw all other `CanvasElementProtocol`s behind the annotations
        annotationCanvasView.insertSubview(canvasElements.view, at: 0)
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
    var canvasView: CanvasView
    let onChange: () -> Void

    init(canvasView: CanvasView,
         onChange: @escaping () -> Void) {
        self.canvasView = canvasView
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
        canvasView.didZoom(to: scrollView.zoomScale)
    }
}
