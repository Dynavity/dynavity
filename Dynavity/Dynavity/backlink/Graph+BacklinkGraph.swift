import CoreGraphics
import Foundation

/// `Graph` will contain `Node<BacklinkNode>`
extension Graph: BacklinkGraph where T == BacklinkNode {
    var backlinkNodes: [BacklinkNode] {
        self.nodes.map({ $0.label })
    }

    var backlinkEdges: [BacklinkEdge] {
        self.edges.map { edge in
            BacklinkEdge(source: edge.source.label, destination: edge.destination.label)
        }
    }

    mutating func addLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode) {
        assert(!self.isDirected)
        let edge = createEdgeBetween(firstItem, and: secondItem)
        self.addEdge(edge)
    }

    mutating func removeLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode) {
        let edge = createEdgeBetween(firstItem, and: secondItem)
        self.removeEdge(edge)
    }

    func getBacklinks(for item: BacklinkNode) -> [BacklinkNode] {
        let node = Node(item)
        return self.adjacentNodesFromNode(node).map({ $0.label })
    }

    mutating func moveBacklinkNode(_ backlinkNode: BacklinkNode, to updatedPos: CGPoint) {
        guard let originalNode = getNodeWithId(id: backlinkNode.id) else {
            return
        }

        let updatedBacklinkNode = originalNode.label.moving(to: updatedPos)

        self.updateNode(originalNode, to: Node(updatedBacklinkNode))
    }

    private func createEdgeBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode) -> Edge<BacklinkNode> {
        let firstNode = Node(firstItem)
        let secondNode = Node(secondItem)
        return Edge(source: firstNode, destination: secondNode)
    }

    private func getNodeWithId(id: UUID?) -> Node<BacklinkNode>? {
        self.nodes.first(where: { $0.label.id == id })
    }
}
