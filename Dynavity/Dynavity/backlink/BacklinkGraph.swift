import CoreGraphics

protocol BacklinkGraph {
    var backlinkNodes: [BacklinkNode] { get }
    var backlinkEdges: [BacklinkEdge] { get }

    func getBacklinks(for item: BacklinkNode) -> [BacklinkNode]
    mutating func addNode(_ node: BacklinkNode)
    mutating func deleteNode(_ node: BacklinkNode)
    mutating func addLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode)
    mutating func removeLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode)
    mutating func moveBacklinkNode(_ backlinkNode: BacklinkNode, to updatedPos: CGPoint)
}
