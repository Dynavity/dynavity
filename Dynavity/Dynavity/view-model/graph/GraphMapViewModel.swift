import CoreGraphics
import Combine
import Foundation

class GraphMapViewModel: ObservableObject {
    @Published var backlinkEngine = BacklinkEngine()

    init() {
        initialiseBacklinkEngine()
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

    func getNodes() -> [BacklinkNode] {
        backlinkEngine.nodes
    }

    func getEdges() -> [BacklinkEdge] {
        backlinkEngine.edges
    }
}
