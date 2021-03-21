import SwiftUI

struct SelectionOverlayView: View {
    var element: CanvasElementProtocol
    @ObservedObject var viewModel: CanvasViewModel

    private let rotationControlSize: CGFloat = 25.0
    private let rotationControlHandleLength: CGFloat = 10.0

    private var rotationControlOffset: CGFloat {
        -(element.height * viewModel.scaleFactor + rotationControlSize + rotationControlHandleLength) / 2.0
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

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: element.width,
                       height: element.height,
                       alignment: .center)
                .allowsHitTesting(false)
            rotationControl
        }
    }
}

struct SelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionOverlayView(element: TestCanvasElement(), viewModel: CanvasViewModel())
    }
}
