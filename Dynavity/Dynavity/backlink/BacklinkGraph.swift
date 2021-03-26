protocol BacklinkGraph {
    var backlinkNodes: [BacklinkNode] { get }
    var backlinkEdges: [BacklinkEdge] { get }
    mutating func addLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode)
    func getBacklinks(for item: BacklinkNode) -> [BacklinkNode]
}
