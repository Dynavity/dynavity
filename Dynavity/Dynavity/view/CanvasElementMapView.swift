import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel
    private let elementViewFactory = CanvasElementViewFactory()
    private let umlConnectorLineWidth: CGFloat = 1.0
    private let umlConnectorLineColor: Color = .black
    private let umlConnectorHitboxWidth: CGFloat = 20.0
    private let umlConnectorHitboxOpacity: Double = 0.001

    private func isSelected(_ element: CanvasElementProtocol) -> Bool {
        viewModel.selectedCanvasElementId == element.id
    }

    private func isSelected(umlConnector: UmlConnector) -> Bool {
        viewModel.selectedUmlConnectorId == umlConnector.id
    }

    private func shouldShowUmlSelectionOverlay(_ element: CanvasElementProtocol) -> Bool {
        element is UmlElementProtocol && (viewModel.umlConnectorStart != nil || isSelected(element))
    }

    private func generatePathFromPoints(_ pathPoints: [CGPoint]) -> Path {
        var points = pathPoints
        return Path { path in
            let origin = points.removeFirst()
            // Translate point to account of CanvasView offset
            path.move(to: origin - viewModel.canvasOrigin + viewModel.canvasViewport / 2.0)
            points.forEach {
                path.addLine(to: $0 - viewModel.canvasOrigin + viewModel.canvasViewport / 2.0)
            }
        }
    }

    private func generateUmlConnectors(_ connector: UmlConnector) -> some View {
        let points = connector.points
        let path = generatePathFromPoints(points)
            .stroke(umlConnectorLineColor, lineWidth: umlConnectorLineWidth)
            .overlay(isSelected(umlConnector: connector)
                        ? ConnectorSelectionOverlayView(connector: connector, viewModel: viewModel)
                        : nil)

        let pathHitbox = generatePathFromPoints(points)
            // Prevent hitbox from covering other connectors, yet allow it to detect touches
            .stroke(Color.white.opacity(umlConnectorHitboxOpacity), lineWidth: umlConnectorHitboxWidth)

        return pathHitbox
            .overlay(path)
            .offset(x: viewModel.canvasOrigin.x, y: viewModel.canvasOrigin.y)
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.getCanvasUmlConnectors(), id: \.id) { connector in
                generateUmlConnectors(connector)
                    .onTapGesture {
                        viewModel.select(umlConnector: connector)
                    }
            }

            ForEach(viewModel.canvasElements, id: \.id) { element in
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
