import CoreGraphics
import Foundation

/// An engine that supports:
/// - Creation of backlinks between items
/// - Retrieval of all backlinks for a particular item
///
/// Items need not be homogeneous.
/// The only requirement is that the items are wrapped in a `BacklinkNode`
/// and that the nodes are uniquely identified by their names.
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

    mutating func addNode(name: String) {
        let randomPoint = CGPoint(x: Int.random(in: -500...500),
                                  y: Int.random(in: -500...500))
        let node = BacklinkNode(name: name, position: randomPoint)
        graph.addNode(node)
    }

    mutating func addNode(node: BacklinkNode) {
        graph.addNode(node)
    }

    mutating func deleteNode(name: String) {
        guard let node = getBacklinkNodeWithName(name: name) else {
            return
        }
        graph.deleteNode(node)
    }

    mutating func renameNode(oldName: String, newName: String) {
        guard let node = getBacklinkNodeWithName(name: oldName) else {
            return
        }
        graph.renameNode(node, newName: newName)
    }

    mutating func addEdge(edge: BacklinkEdge) {
        graph.addLinkBetween(edge.source, and: edge.destination)
    }

    mutating func addLinkBetween(_ firstItemName: String, and secondItemName: String) {
        guard let firstNode = getBacklinkNodeWithName(name: firstItemName),
              let secondNode = getBacklinkNodeWithName(name: secondItemName) else {
            return
        }
        graph.addLinkBetween(firstNode, and: secondNode)
    }

    mutating func removeLinkBetween(_ firstItemName: String, and secondItemName: String) {
        guard let firstNode = getBacklinkNodeWithName(name: firstItemName),
              let secondNode = getBacklinkNodeWithName(name: secondItemName) else {
            return
        }
        graph.removeLinkBetween(firstNode, and: secondNode)
    }

    func getBacklinks(for name: String) -> [BacklinkNode] {
        guard let node = getBacklinkNodeWithName(name: name) else {
            return []
        }
        return graph.getBacklinks(for: node)
    }

    mutating func moveBacklinkNode(_ backlinkNode: BacklinkNode, to updatedPos: CGPoint) {
        graph.moveBacklinkNode(backlinkNode, to: updatedPos)
    }

    private func getBacklinkNodeWithName(name: String) -> BacklinkNode? {
        self.nodes.first(where: { $0.name == name })
    }
}
