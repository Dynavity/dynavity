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
    private var topLeftCorner: CGSize {
        CGSize(width: -halfWidth, height: -halfHeight)
    }
    private var topRightCorner: CGSize {
        CGSize(width: halfWidth, height: -halfHeight)
    }
    private var bottomLeftCorner: CGSize {
        CGSize(width: -halfWidth, height: halfHeight)
    }
    private var bottomRightCorner: CGSize {
        CGSize(width: halfWidth, height: halfHeight)
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

    private var resizeControl: some View {
        Rectangle()
            .fill(Color.white)
            .frame(width: resizeControlSize, height: resizeControlSize)
            .border(Color.blue, width: resizeControlSize * resizeControlBorderPercentage)
            // Force the resize control to be the same size regardless of scale factor.
            .scaleEffect(1.0 / viewModel.scaleFactor)
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
            resizeControl
                .offset(topLeftCorner)
            resizeControl
                .offset(topRightCorner)
            resizeControl
                .offset(bottomLeftCorner)
            resizeControl
                .offset(bottomRightCorner)
        }
    }
}

struct SelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionOverlayView(element: TestCanvasElement(), viewModel: CanvasViewModel())
    }
}
