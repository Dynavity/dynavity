import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let elementViewFactory = CanvasElementViewFactory()
    private let umlConnectorLineWidth: CGFloat = 1.0
    private let umlConnectorLineColor: Color = .black

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.moveSelectedCanvasElement(by: value.translation)
            }
    }

    private func isSelected(_ element: CanvasElementProtocol) -> Bool {
        viewModel.selectedCanvasElementId == element.id
    }

    private func generateUmlConnectors(_ connector: UmlConnector) -> some View {
        var points = connector.points
        return Path { path in
            let origin = points.removeFirst()
            // Translate point to account of CanvasView offset
            path.move(to: CGPoint(x: origin.x - viewModel.canvasOrigin.x,
                                  y: origin.y - viewModel.canvasOrigin.y))
            points.forEach {
                path.addLine(to: CGPoint(x: $0.x - viewModel.canvasOrigin.x,
                                         y: $0.y - viewModel.canvasOrigin.y))
            }
        }
        .stroke(umlConnectorLineColor, lineWidth: umlConnectorLineWidth)
        .gesture(testGesture)
        .offset(x: viewModel.canvasOrigin.x, y: viewModel.canvasOrigin.y)
    }

    var testGesture: some Gesture {
        TapGesture().onEnded({ _ in print("Tap gesture on red path") })
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.getCanvasUmlConnectors(), id: \.id) { connector in
                generateUmlConnectors(connector)
            }

            ForEach(viewModel.getCanvasElements(), id: \.id) { element in
                elementViewFactory.createView(element: element)
                    .frame(width: element.width, height: element.height)
                    .shouldAddCardOverlay(shouldAdd: !(element is UmlElementProtocol))
                    .onTapGesture {
                        viewModel.select(canvasElement: element)
                    }
                    .gesture(isSelected(element) ? dragGesture : nil)
                    .overlay(isSelected(element) ? SelectionOverlayView(element: element, viewModel: viewModel) : nil)
                    .overlay(isSelected(element) && element is UmlElementProtocol
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
