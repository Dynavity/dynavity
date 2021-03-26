/// An engine that supports:
/// - Creation of backlinks between items
/// - Retrieval of all backlinks for a particular item
///
/// Items need not be homogeneous. The only requirement is that the items are wrapped in an `AnyNamedIdentifiable`.
struct BacklinkEngine {
    private var graph: BacklinkGraph = Graph<AnyNamedIdentifiable>(isDirected: false)

    var nodes: [BacklinkNode] {
        graph.backlinkNodes
    }

    var edges: [BacklinkEdge] {
        var output: [BacklinkEdge] = []
        for edge in graph.backlinkEdges {
            // We remove "duplicate" edges. i.e. if (u, v) is included, we do not include (v, u)
            if !output.contains(where: { $0.source == edge.destination && $0.destination == edge.source }) {
                output.append(edge)
            }
        }
        return output
    }

    mutating func addLinkBetween(_ firstItem: AnyNamedIdentifiable, and secondItem: AnyNamedIdentifiable) {
        graph.addLinkBetween(firstItem, and: secondItem)
    }

    func getBacklinks(for item: AnyNamedIdentifiable) -> [AnyNamedIdentifiable] {
        graph.getBacklinks(for: item)
    }
}
