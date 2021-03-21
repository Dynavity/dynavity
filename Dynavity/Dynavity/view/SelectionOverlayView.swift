import SwiftUI

struct SelectionOverlayView: View {
    var element: CanvasElementProtocol
    @ObservedObject var viewModel: CanvasViewModel

    private let rotationControlSize: CGFloat = 25.0
    private let rotationControlHandleLength: CGFloat = 10.0
    private let resizeControlSize: CGFloat = 15.0
    private let resizeControlBorderPercentage: CGFloat = 0.1
    private let resizeControlHitboxScale: CGFloat = 2.0
    private let selectionOutlineWidth: CGFloat = 2.0
    private let overlayColor = Color.blue

    private var rotationControlOffset: CGFloat {
        -(element.height * viewModel.scaleFactor + rotationControlSize + rotationControlHandleLength) / 2.0
    }
    private var halfWidth: CGFloat {
        element.width / 2.0
    }
    private var halfHeight: CGFloat {
        element.height / 2.0
    }

    enum ResizeControlAnchor: CaseIterable {
        case topLeftCorner
        case topRightCorner
        case bottomLeftCorner
        case bottomRightCorner
    }

    private func getResizeControlPosition(_ anchor: ResizeControlAnchor) -> CGSize {
        switch anchor {
        case .topLeftCorner:
            return CGSize(width: -halfWidth, height: -halfHeight)
        case .topRightCorner:
            return CGSize(width: halfWidth, height: -halfHeight)
        case .bottomLeftCorner:
            return CGSize(width: -halfWidth, height: halfHeight)
        case .bottomRightCorner:
            return CGSize(width: halfWidth, height: halfHeight)
        }
    }

    private func getResizeControlGesture(_ anchor: ResizeControlAnchor) -> some Gesture {
        // Global coordinate space is necessary to accurately track translations.
        DragGesture(coordinateSpace: .global)
            .onChanged { value in
                viewModel.handleDragChange(value, anchor: anchor)
            }
            .onEnded { _ in
                viewModel.handleDragEnd()
            }
    }

    private var outline: some View {
        Rectangle()
            .fill(Color.clear)
            // Force the border to be the same size regardless of scale factor.
            .border(overlayColor, width: selectionOutlineWidth / viewModel.scaleFactor)
            .frame(width: element.width,
                   height: element.height,
                   alignment: .center)
            .allowsHitTesting(false)
    }

    private var rotationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                // Calculate the translation with respect to the center of the canvas element.
                var translationsFromCenter = value.translation
                translationsFromCenter.height += rotationControlOffset
                viewModel.rotateSelectedCanvasElement(by: translationsFromCenter)
            }
    }

    private var rotationControl: some View {
        VStack(spacing: .zero) {
            ZStack {
                Circle()
                    .fill(Color.white)
                Image(systemName: "arrow.triangle.2.circlepath.circle")
                    .resizable()
                    .foregroundColor(overlayColor)
            }
            .frame(width: rotationControlSize, height: rotationControlSize)
            Rectangle()
                .fill(overlayColor)
                .frame(width: 1.0, height: rotationControlHandleLength)
        }
        .gesture(rotationGesture)
        .offset(y: rotationControlOffset)
        // Force the rotation control to be the same size regardless of scale factor.
        .scaleEffect(1.0 / viewModel.scaleFactor)
    }

    private func makeResizeControl(_ resizeControl: ResizeControlAnchor) -> some View {
        Group {
            Rectangle()
                .fill(Color.white)
                .frame(width: resizeControlSize, height: resizeControlSize)
                .border(overlayColor, width: resizeControlSize * resizeControlBorderPercentage)
        }
        // Make hitbox of resize control slightly larger.
        .frame(
            width: resizeControlSize * resizeControlHitboxScale,
            height: resizeControlSize * resizeControlHitboxScale
        )
        .contentShape(Rectangle())
        // Force the resize control to be the same size regardless of scale factor.
        .scaleEffect(1.0 / viewModel.scaleFactor)
        .offset(getResizeControlPosition(resizeControl))
        .gesture(getResizeControlGesture(resizeControl))
    }

    var body: some View {
        ZStack {
            outline
            rotationControl
            ForEach(ResizeControlAnchor.allCases, id: \.self) { corner in
                makeResizeControl(corner)
            }
        }
    }
}

struct SelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionOverlayView(element: TestCanvasElement(), viewModel: CanvasViewModel())
    }
}
