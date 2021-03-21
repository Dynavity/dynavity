import SwiftUI

struct SelectionOverlayView: View {
    var element: CanvasElementProtocol
    @ObservedObject var viewModel: CanvasViewModel

    private let rotationControlSize: CGFloat = 25.0
    private let rotationControlHandleLength: CGFloat = 10.0
    private let resizeControlSize: CGFloat = 15.0
    private let resizeControlBorderPercentage: CGFloat = 0.1

    private var rotationControlOffset: CGFloat {
        -(element.height * viewModel.scaleFactor + rotationControlSize + rotationControlHandleLength) / 2.0
    }
    private var halfWidth: CGFloat {
        element.width / 2.0
    }
    private var halfHeight: CGFloat {
        element.height / 2.0
    }
    private enum ResizeControl: CaseIterable {
        case topLeftCorner
        case topRightCorner
        case bottomLeftCorner
        case bottomRightCorner
    }

    private func getResizeControlPosition(_ resizeControl: ResizeControl) -> CGSize {
        switch resizeControl {
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

    private func getResizeControlGesture(_ resizeControl: ResizeControl) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // TODO: Implement this.
                print(value.translation)
            }
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
            }
            .frame(width: rotationControlSize, height: rotationControlSize)
            Rectangle()
                .fill(Color.black)
                .frame(width: 1.0, height: rotationControlHandleLength)
        }
        .gesture(rotationGesture)
        .offset(y: rotationControlOffset)
        // Force the rotation control to be the same size regardless of scale factor.
        .scaleEffect(1.0 / viewModel.scaleFactor)
    }

    private func makeResizeControl(_ resizeControl: ResizeControl) -> some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: resizeControlSize, height: resizeControlSize)
            .border(Color.blue, width: resizeControlSize * resizeControlBorderPercentage)
            // Force the resize control to be the same size regardless of scale factor.
            .scaleEffect(1.0 / viewModel.scaleFactor)
            .offset(getResizeControlPosition(resizeControl))
            .gesture(getResizeControlGesture(resizeControl))
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: element.width,
                       height: element.height,
                       alignment: .center)
                .allowsHitTesting(false)
            rotationControl
            ForEach(ResizeControl.allCases, id: \.self) { corner in
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
