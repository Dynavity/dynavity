import SwiftUI

struct ConnectorSelectionOverlayView: View {
    var connector: UmlConnector
    @ObservedObject var viewModel: CanvasViewModel
    @State private var shouldDisplayDeleteAlert = true

    private let overlayDestructiveColor: Color = .red
    private let extendedControlSize: CGFloat = 25.0
    private let extendedControlHandleLength: CGFloat = 15.0

    private let connectorOverlayColor: Color = .orange
    private let connectorOverlayWidth: CGFloat = 5.0

    private var extendedControlOffsetX: CGFloat {
        -(viewModel.scaleFactor + extendedControlSize + extendedControlHandleLength) / 2.0
    }

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
        .offset(x: viewModel.canvasOrigin.x, y: viewModel.canvasOrigin.y)
    }

    private var deleteAlert: Alert {
        Alert(
            title: Text("Are you sure?"),
            message: Text("This will delete the element!"),
            primaryButton: .destructive(Text("Delete"), action: {
                viewModel.removeUmlConnector(connector)
            }),
            secondaryButton: .cancel()
        )
    }

    private var deleteGesture: some Gesture {
        TapGesture()
            .onEnded {
                shouldDisplayDeleteAlert = true
            }
    }

    private var deleteControl: some View {
        HStack(spacing: .zero) {
            Image(systemName: "trash.circle")
                .resizable()
                .foregroundColor(overlayDestructiveColor)
                .frame(width: extendedControlSize, height: extendedControlSize)
            Rectangle()
                .fill(overlayDestructiveColor)
                .frame(width: extendedControlHandleLength, height: 1.0)
        }
        .gesture(deleteGesture)
        .offset(x: extendedControlOffsetX)
        .alert(isPresented: $shouldDisplayDeleteAlert) { () -> Alert in
            deleteAlert
        }
    }

    private var popoverMenu: some View {
        VStack {
            deleteControl
        }
        .frame(width: 200, height: 200, alignment: .center)
        .background(Color.blue)
    }

    var body: some View {
        VStack {
            generateConnectorOverlay(connector)
            popoverMenu
        }
    }
}

struct ConnectorSelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        let sourceElement = DiamondUmlElement(position: viewModel.canvasOrigin)
        let destElement = DiamondUmlElement(position: viewModel.canvasOrigin
                                                + CGPoint(x: 250, y: 250))
        let umlConnector = UmlConnector(connects: (fromElement: sourceElement.id, toElement: destElement.id),
                                        connectingSide: (fromSide: ConnectorConnectingSide.middleRight,
                                                         toSide: ConnectorConnectingSide.middleLeft))
        ConnectorSelectionOverlayView(connector: umlConnector, viewModel: viewModel)
    }
}
