import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel = CanvasViewModel()

    // For drag interactions
    @State var portalPosition: CGPoint = .zero
    @State var dragOffset: CGSize = .zero
    @State var isDragging: Bool = false
    @State var isDraggingCanvas: Bool = false

    // For zoom interactions
    @State var zoomScale: CGFloat = 1.0
    @State var initialZoomScale: CGFloat?
    @State var initialPortalPosition: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                CanvasElementMapView(elements: $viewModel.canvas.canvasElements)
                    .scaleEffect(zoomScale)
                    .offset(x: portalPosition.x + dragOffset.width,
                            y: portalPosition.y + dragOffset.height)
                    .animation(.easeIn)
            }
            .gesture(DragGesture()
                        .onChanged { value in
                            handleDragChange(value, containerSize: geometry.size)
                        }
                        .onEnded { value in
                                handleDragEnd(value)
                        })
            .gesture(MagnificationGesture()
                        .onChanged { value in
                            handleScaleChange(value)
                        }
                        .onEnded { value in
                            handleScaleChange(value)
                            initialZoomScale = nil
                            initialPortalPosition = nil
                        })
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        CanvasView(viewModel: viewModel)
    }
}

extension CanvasView {
    func handleDragChange(_ value: DragGesture.Value, containerSize: CGSize) {
        isDragging = true
        // TODO: Add logic to determine dragging canvas or canvas element
        isDraggingCanvas = true

        if isDraggingCanvas {
            dragOffset = value.translation
        } else {
            // TODO: Add handle canvas element translation
        }
    }

    func handleDragEnd(_ value: DragGesture.Value) {
        isDragging = false
        dragOffset = .zero

        if isDraggingCanvas {
            portalPosition = CGPoint(
                x: portalPosition.x + value.translation.width,
                y: portalPosition.y + value.translation.height
            )
        }
    }

    func scaledOffset(_ scale: CGFloat, initialValue: CGPoint) -> CGPoint {
        let newX = initialValue.x * scale
        let newY = initialValue.y * scale
        return CGPoint(x: newX, y: newY)
    }

    func clampedScale(_ scale: CGFloat, initialValue: CGFloat?) -> (scale: CGFloat, didClamp: Bool) {
        let minScale = CGFloat(0.1)
        let maxScale = CGFloat(2.0)
        let raw = scale.magnitude * (initialValue ?? maxScale)
        let value = max(minScale, min(maxScale, raw))
        let didClamp = raw != value
        return (value, didClamp)
    }

    func handleScaleChange(_ value: CGFloat) {
        if initialZoomScale == nil {
            initialZoomScale = zoomScale
            initialPortalPosition = portalPosition
        }

        let clamped = clampedScale(value, initialValue: initialZoomScale)
        zoomScale = clamped.scale
        if !clamped.didClamp,
           let point = initialPortalPosition {
            portalPosition = scaledOffset(value, initialValue: point)
        }
    }
}
