import CoreGraphics

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

    mutating func addLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode) {
        graph.addLinkBetween(firstItem, and: secondItem)
    }

    func getBacklinks(for item: BacklinkNode) -> [BacklinkNode] {
        graph.getBacklinks(for: item)
    }

    mutating func moveBacklinkNode(_ backlinkNode: BacklinkNode, by translation: CGSize) {
        graph.moveBacklinkNode(backlinkNode, by: translation)
    }
}
