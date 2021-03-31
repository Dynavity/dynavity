import CoreGraphics

protocol BacklinkGraph {
    var backlinkNodes: [BacklinkNode] { get }
    var backlinkEdges: [BacklinkEdge] { get }

    func getBacklinks(for item: BacklinkNode) -> [BacklinkNode]
    mutating func addLinkBetween(_ firstItem: BacklinkNode, and secondItem: BacklinkNode)
    mutating func moveBacklinkNode(_ backlinkNode: BacklinkNode, to updatedPos: CGPoint)
}
