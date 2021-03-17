import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    // For drag interactions
    @State var viewPositionFromCentre = CGPoint()
    @State var dragOffset = CGSize()
    @State var isDragging = false

    // For zoom interactions
    @State var zoomScale = CGFloat(1.0)
    @State var initialZoomScale: CGFloat?
    @State var initialViewPositionFromCentre: CGPoint?

    private var tapGesture: some Gesture {
        TapGesture(count: 1)
            .onEnded { _ in
                viewModel.unselectCanvasElement()
            }
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                handleDragChange(value)
            }
            .onEnded { value in
                handleDragEnd(value)
            }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                handleScaleChange(value)
            }
            .onEnded { value in
                handleScaleChange(value)
                initialZoomScale = nil
                initialViewPositionFromCentre = nil
            }
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Rectangle()
                    .fill(Color.white)
                CanvasElementMapView(viewModel: viewModel)
                    .scaleEffect(zoomScale)
                    .offset(x: viewPositionFromCentre.x + dragOffset.width,
                            y: viewPositionFromCentre.y + dragOffset.height)
                    .animation(.easeIn)
            }
            .gesture(tapGesture)
            .gesture(dragGesture)
            .gesture(magnificationGesture)
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
    func handleDragChange(_ value: DragGesture.Value) {
        isDragging = true
        dragOffset = value.translation
    }

    func handleDragEnd(_ value: DragGesture.Value) {
        isDragging = false
        dragOffset = .zero

        viewPositionFromCentre = CGPoint(
            x: viewPositionFromCentre.x + value.translation.width,
            y: viewPositionFromCentre.y + value.translation.height
        )
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
        let value = raw.clamped(to: minScale...maxScale)
        let didClamp = raw != value
        return (value, didClamp)
    }

    func handleScaleChange(_ value: CGFloat) {
        if initialZoomScale == nil {
            initialZoomScale = zoomScale
            initialViewPositionFromCentre = viewPositionFromCentre
        }

        let clamped = clampedScale(value, initialValue: initialZoomScale)
        zoomScale = clamped.scale
        if !clamped.didClamp,
           let point = initialViewPositionFromCentre {
            viewPositionFromCentre = scaledOffset(value, initialValue: point)
        }
    }
}
