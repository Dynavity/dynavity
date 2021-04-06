import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let elementViewFactory = CanvasElementViewFactory()

    private func isSelected(_ element: CanvasElementProtocol) -> Bool {
        viewModel.selectedCanvasElement === element
    }

    private func shouldShowUmlSelectionOverlay(_ element: CanvasElementProtocol) -> Bool {
        element is UmlElementProtocol && (viewModel.umlConnectorStart != nil || isSelected(element))
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.getCanvasUmlConnectors(), id: \.id) { connector in
                UmlConnectorView(viewModel: viewModel, connector: connector)
                    .onTapGesture {
                        viewModel.select(umlConnector: connector)
                    }
            }

            ForEach(viewModel.canvasElements.map({ AnyCanvasElementProtocol(canvasElement: $0) })) { elementWrapper in
                let element = elementWrapper.canvasElement
                elementViewFactory.createView(element: element)
                    .frame(width: element.width, height: element.height)
                    .shouldAddCardOverlay(shouldAdd: !(element is UmlElementProtocol))
                    .onTapGesture {
                        viewModel.select(canvasElement: element)
                    }
                    .overlay(isSelected(element) ? SelectionOverlayView(element: element, viewModel: viewModel) : nil)
                    .overlay(shouldShowUmlSelectionOverlay(element)
                                ? UmlSelectionOverlayView(element: element, viewModel: viewModel)
                                : nil)
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
