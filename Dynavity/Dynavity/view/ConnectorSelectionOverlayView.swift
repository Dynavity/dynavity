import SwiftUI

struct ConnectorSelectionOverlayView: View {
    var connector: UmlConnector
    @ObservedObject var viewModel: CanvasViewModel

    private let overlayDestructiveColor: Color = .red
    private let deleteControlBackgroundColor: Color = .white
    private let extendedControlSize: CGFloat = 25.0

    private let connectorOverlayColor: Color = .orange
    private let connectorOverlayWidth: CGFloat = 5.0

    private func generateConnectorOverlay(_ connector: UmlConnector) -> some View {
        var points = connector.points
        return Path { path in
            let origin = points.removeFirst()
            // Translate point to account of CanvasView offset
            path.move(to: origin - viewModel.canvasOrigin + viewModel.canvasViewport / 2.0)
            points.forEach {
                path.addLine(to: $0 - viewModel.canvasOrigin + viewModel.canvasViewport / 2.0)
            }
        }
        .stroke(connectorOverlayColor, lineWidth: connectorOverlayWidth)
        .onTapGesture {
            viewModel.select(umlConnector: connector)
        }
    }

    private func getConnectorMidPoint() -> CGPoint {
        let points = connector.points
        // Only source and dest, no bends
        if points.count == 2 {
            return CGPoint(x: (points[0].x + points[1].x) / 2,
                           y: (points[0].y + points[1].y) / 2)
        }
        return points[(points.count / 2)]
    }

    private var deleteControl: some View {
        HStack(spacing: .zero) {
            Image(systemName: "trash.circle")
                .resizable()
                .foregroundColor(overlayDestructiveColor)
                .background(deleteControlBackgroundColor)
                .frame(width: extendedControlSize, height: extendedControlSize)
        }
        .position(getConnectorMidPoint() - viewModel.canvasOrigin + viewModel.canvasViewport / 2.0)
        .onTapGesture {
            viewModel.removeUmlConnector(connector)
        }
    }

    var body: some View {
        ZStack {
            generateConnectorOverlay(connector)
            deleteControl
        }
    }
}

struct ConnectorSelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        let sourceElement = DiamondUmlElement(position: viewModel.canvasOrigin)
        let destElement = DiamondUmlElement(position: viewModel.canvasOrigin
                                                + CGPoint(x: 250, y: 250))
        let umlConnector = UmlConnector(points: [],
                                        connects: (fromElement: sourceElement, toElement: destElement),
                                        connectingSide: (fromSide: ConnectorConnectingSide.middleRight,
                                                         toSide: ConnectorConnectingSide.middleLeft))
        ConnectorSelectionOverlayView(connector: umlConnector, viewModel: viewModel)
    }
}
