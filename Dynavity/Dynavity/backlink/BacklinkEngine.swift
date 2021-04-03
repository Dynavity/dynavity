import CoreGraphics
import Foundation

/// An engine that supports:
/// - Creation of backlinks between items
/// - Retrieval of all backlinks for a particular item
///
/// Items need not be homogeneous. The only requirement is that the items are wrapped in a `BacklinkNode`.
struct BacklinkEngine {
    private var graph: BacklinkGraph = Graph<BacklinkNode>(isDirected: false)

    var nodes: [BacklinkNode] {
        graph.backlinkNodes
    }

    var edges: [BacklinkEdge] {
        var output: [BacklinkEdge] = []
        for edge in graph.backlinkEdges {
            // We exclude duplicate edges.
            // Specifically, we want to exclude (v, u) when (u, v) is already included.
            if !output.contains(edge) {
                output.append(edge)
            }
        }
        return output
    }

    mutating func addNode(id: UUID, name: String) {
        // TODO: figure out a way to position new nodes
        let node = BacklinkNode(id: id, name: name, position: .zero)
        graph.addNode(node)
    }

    mutating func addLinkBetween(_ firstItemId: UUID, and secondItemId: UUID) {
        guard let firstNode = getBacklinkNodeWithId(id: firstItemId),
              let secondNode = getBacklinkNodeWithId(id: secondItemId) else {
            return
        }
        graph.addLinkBetween(firstNode, and: secondNode)
    }

    mutating func removeLinkBetween(_ firstItemId: UUID, and secondItemId: UUID) {
        guard let firstNode = getBacklinkNodeWithId(id: firstItemId),
              let secondNode = getBacklinkNodeWithId(id: secondItemId) else {
            return
        }
        graph.removeLinkBetween(firstNode, and: secondNode)
    }

    func getBacklinks(for id: UUID) -> [BacklinkNode] {
        guard let node = getBacklinkNodeWithId(id: id) else {
            return []
        }
        return graph.getBacklinks(for: node)
    }

    mutating func moveBacklinkNode(_ backlinkNode: BacklinkNode, to updatedPos: CGPoint) {
        graph.moveBacklinkNode(backlinkNode, to: updatedPos)
    }

    private func getBacklinkNodeWithId(id: UUID?) -> BacklinkNode? {
        self.nodes.first(where: { $0.id == id })
    }
}
