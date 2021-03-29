import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let elementViewFactory = CanvasElementViewFactory()

    private func isSelected(_ element: CanvasElementProtocol) -> Bool {
        viewModel.selectedCanvasElementId == element.id
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.getCanvasElements(), id: \.id) { element in
                elementViewFactory.createView(element: element)
                    .frame(width: element.width, height: element.height)
                    .addCardOverlay()
                    .onTapGesture {
                        viewModel.select(canvasElement: element)
                    }
                    .overlay(isSelected(element) ? SelectionOverlayView(element: element, viewModel: viewModel) : nil)
                    .rotationEffect(.radians(element.rotation))
                    .offset(x: element.position.x, y: element.position.y)
            }
        }
    }
}

struct CanvasElementMapView_Previews: PreviewProvider {
    @ObservedObject static var viewModel = CanvasViewModel()
    @State static var scale: CGFloat = 1.0

    static var previews: some View {
        CanvasElementMapView(viewModel: viewModel)
    }
}
