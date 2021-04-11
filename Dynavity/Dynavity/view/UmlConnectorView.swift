import SwiftUI

struct UmlConnectorView: View {
    @ObservedObject var viewModel: CanvasViewModel
    var connector: UmlConnector

    private let umlConnectorLineWidth: CGFloat = 1.0
    private let umlConnectorLineColor: Color = .black
    private let umlConnectorHitboxWidth: CGFloat = 20.0
    private let umlConnectorHitboxOpacity: Double = 0.001

    private func isSelected(umlConnector: UmlConnector) -> Bool {
        viewModel.selectedUmlConnector === umlConnector
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

    var body: some View {
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
}

struct UmlConnectorView_Previews: PreviewProvider {
    @ObservedObject static var viewModel = CanvasViewModel()
    static var previews: some View {
        let connector = UmlConnector(points: [],
                                     connects: (fromElement: ActivityUmlElement(position: .zero, shape: .diamond),
                                                toElement: ActivityUmlElement(position: .zero, shape: .diamond)),
                                     connectingSide: (fromSide: ConnectorConnectingSide.middleRight,
                                                      toSide: ConnectorConnectingSide.middleLeft))
        UmlConnectorView(viewModel: viewModel, connector: connector)
    }
}
