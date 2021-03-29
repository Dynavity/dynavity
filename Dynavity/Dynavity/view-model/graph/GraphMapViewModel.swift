import CoreGraphics
import Combine
import Foundation

class GraphMapViewModel: ObservableObject {
    @Published var backlinkEngine = BacklinkEngine()
    @Published var selectedNode: BacklinkNode?

    init() {
        initialiseBacklinkEngine()
    }

    func getNodes() -> [BacklinkNode] {
        backlinkEngine.nodes
    }

    func getEdges() -> [BacklinkEdge] {
        backlinkEngine.edges
    }

    func moveSelectedNode(by translation: CGSize) {
        guard let selectedNode = selectedNode else {
            return
        }
        backlinkEngine.moveBacklinkNode(selectedNode, by: translation)
    }

    func hitTest(tapPos: CGPoint, viewportSize: CGSize,
                 viewportZoomScale: CGFloat, viewportOriginOffset: CGPoint) {
        for node in self.getNodes() {
            let processedPosition = getPositionRelativeToViewport(point: node.position,
                                                                  viewportSize: viewportSize,
                                                                  viewportZoomScale: viewportZoomScale,
                                                                  viewportOriginOffset: viewportOriginOffset)
            let dist = tapPos.distance(to: processedPosition) / viewportZoomScale

            if dist < NodeView.radius {
                self.selectedNode = node
            }
        }
    }

    private func initialiseBacklinkEngine() {
        let nodes: [BacklinkNode] = (0..<20).map { i in
            BacklinkNode(id: UUID(), name: "Node \(i)", position: CGPoint(x: Int.random(in: 100...700),
                                                                          y: Int.random(in: 100...700)))
        }

        for i in 0..<nodes.endIndex - 1 {
            backlinkEngine.addLinkBetween(nodes[i], and: nodes[i + 1])
        }
    }

    private func getPositionRelativeToViewport(point: CGPoint,
                                               viewportSize: CGSize,
                                               viewportZoomScale: CGFloat,
                                               viewportOriginOffset: CGPoint) -> CGPoint {
        point
            .scale(by: viewportZoomScale)
            .translateBy(x: viewportSize.width / 2, y: viewportSize.height / 2)
            .translateBy(x: viewportOriginOffset.x, y: viewportOriginOffset.y)
    }
}
