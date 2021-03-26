protocol BacklinkGraph {
    var backlinkNodes: [BacklinkNode] { get }
    var backlinkEdges: [BacklinkEdge] { get }
    mutating func addLinkBetween(_ firstItem: AnyNamedIdentifiable, and secondItem: AnyNamedIdentifiable)
    func getBacklinks(for item: AnyNamedIdentifiable) -> [AnyNamedIdentifiable]
}
