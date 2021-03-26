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
        let firstNode = Node(firstItem)
        let secondNode = Node(secondItem)
        let edge = Edge(source: firstNode, destination: secondNode)
        self.addEdge(edge)
    }

    func getBacklinks(for item: BacklinkNode) -> [BacklinkNode] {
        let node = Node(item)
        return self.adjacentNodesFromNode(node).map({ $0.label })
    }
}
