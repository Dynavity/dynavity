import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let elementViewFactory = CanvasElementViewFactory()
    private let umlConnectorLineWidth: CGFloat = 1.0
    private let umlConnectorLineColor: Color = .black

    private func isSelected(_ element: CanvasElementProtocol) -> Bool {
        viewModel.selectedCanvasElementId == element.id
    }

    private func shouldShowUmlSelectionOverlay(_ element: CanvasElementProtocol) -> Bool {
        element is UmlElementProtocol && (viewModel.umlConnectorStart != nil || isSelected(element))
    }

    private func generateUmlConnectors(_ connector: UmlConnector) -> some View {
        var points = connector.points
        let viewOffset = (viewModel.canvasViewport / 2.0) - viewModel.canvasOrigin
        let endPoint = points[points.count - 1]
        let secondEndPoint = points[points.count - 2]
        return Path { path in
            let origin = points.removeFirst()
            path.move(to: origin + viewOffset)
            points.forEach {
                path.addLine(to: $0 + viewOffset)
            }
            path.addArrow(start: secondEndPoint + viewOffset,
                          end: endPoint + viewOffset)
        }
        .stroke(umlConnectorLineColor, lineWidth: umlConnectorLineWidth)
        .gesture(testGesture)
        .offset(x: viewModel.canvasOrigin.x, y: viewModel.canvasOrigin.y)
    }

    // TODO: Change this guesture to select uml connector
    var testGesture: some Gesture {
        TapGesture().onEnded({ _ in print("Tap gesture UML connector") })
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
