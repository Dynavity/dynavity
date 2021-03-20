import SwiftUI

struct SelectionOverlayView: View {
    var element: CanvasElementProtocol
    var viewModel: CanvasViewModel

    private let rotationControlSize: CGFloat = 20.0
    private let rotationControlHandleLength: CGFloat = 10.0

    private var rotationGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.rotateSelectedCanvasElement(by: value.translation)
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
        .offset(y: -(element.height + rotationControlSize + rotationControlHandleLength) / 2.0)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.green)
                .frame(width: element.width,
                       height: element.height,
                       alignment: .center)
            rotationControl
        }
    }
}

struct SelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionOverlayView(element: TestCanvasElement(), viewModel: CanvasViewModel())
    }
}
