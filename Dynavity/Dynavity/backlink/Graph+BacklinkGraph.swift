extension Graph: BacklinkGraph where T == AnyNamedIdentifiable {
    var backlinkNodes: [BacklinkNode] {
        self.nodes
    }

    var backlinkEdges: [BacklinkEdge] {
        self.edges
    }

    mutating func addLinkBetween(_ firstItem: AnyNamedIdentifiable, and secondItem: AnyNamedIdentifiable) {
        assert(!self.isDirected)
        let firstNode = Node(firstItem)
        let secondNode = Node(secondItem)
        let edge = Edge(source: firstNode, destination: secondNode)
        self.addEdge(edge)
    }

    func getBacklinks(for item: AnyNamedIdentifiable) -> [AnyNamedIdentifiable] {
        let node = Node(item)
        return self.adjacentNodesFromNode(node).map({ $0.label })
    }
}
