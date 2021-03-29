/// An engine that supports:
/// - Creation of backlinks between items
/// - Retrieval of all backlinks for a particular item
///
/// Items need not be homogeneous. The only requirement is that the items are wrapped in an `AnyNamedIdentifiable`.
struct BacklinkEngine {
    private var graph: BacklinkGraph = Graph<AnyNamedIdentifiable>(isDirected: false)

    mutating func addLinkBetween(_ firstItem: AnyNamedIdentifiable, and secondItem: AnyNamedIdentifiable) {
        graph.addLinkBetween(firstItem, and: secondItem)
    }

    func getBacklinks(for item: AnyNamedIdentifiable) -> [AnyNamedIdentifiable] {
        graph.getBacklinks(for: item)
    }
}
