import SwiftUI

struct UmlSelectionOverlayView: View {
    var element: CanvasElementProtocol
    @ObservedObject var viewModel: CanvasViewModel

    private let connectorControlSize: CGFloat = 20.0
    private let connectorControlBorderPercentage: CGFloat = 0.1
    private let connectorControlHitboxScale: CGFloat = 2.0
    private let overlayColor = Color.blue

    private var halfWidth: CGFloat {
        element.width / 2
    }

    private var halfHeight: CGFloat {
        element.height / 2
    }

    enum ConnectorControlAnchor: CaseIterable {
        case middleLeft
        case middleRight
        case middleBottom
    }

    private func getConnectorControlPosition(_ anchor: ConnectorControlAnchor) -> CGSize {
        switch anchor {
        case .middleLeft:
            return CGSize(width: -halfWidth, height: 0)
        case .middleRight:
            return CGSize(width: halfWidth, height: 0)
        case .middleBottom:
            return CGSize(width: 0, height: halfHeight)
        }
    }

    private func makeConnectorControl(_ connectorControl: ConnectorControlAnchor) -> some View {
        let tapGesture = TapGesture()
            .onEnded { _ in
                guard let element = element as? UmlElementProtocol else {
                    return
                }
                viewModel.handleConnectorTap(element, anchor: connectorControl)
            }

        return Group {
            ZStack {
                Circle()
                    .fill(Color.white)
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(overlayColor)
            }
            .frame(width: connectorControlSize, height: connectorControlSize)
        }
        .frame(
            width: connectorControlSize * connectorControlHitboxScale,
            height: connectorControlSize * connectorControlHitboxScale
        )
        .contentShape(Rectangle())
        .scaleEffect(1.0 / viewModel.scaleFactor)
        .offset(getConnectorControlPosition(connectorControl))
        .gesture(tapGesture)
    }

    var body: some View {
        ZStack {
            ForEach(ConnectorControlAnchor.allCases, id: \.self) { side in
                makeConnectorControl(side)
            }
        }
    }
}

struct UmlSelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        UmlSelectionOverlayView(element: DiamondUmlElement(position: viewModel.canvasOrigin),
                                viewModel: viewModel)
    }
}
