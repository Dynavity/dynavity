import Foundation

struct BacklinkEdge {
    // TODO: there's probably a better way of generating an ID
    // from the IDs of source and destination
    var id: Int {
        self.hashValue
    }
    let source: BacklinkNode
    let destination: BacklinkNode
}

extension BacklinkEdge: Hashable {
    /// Two BacklinkEdge are equal if:
    /// 1. Their source and destination nodes are the same
    /// 2. Their source and destination nodes are the opposite of each other's
    static func == (lhs: BacklinkEdge, rhs: BacklinkEdge) -> Bool {
        let sameSourceAndDest = lhs.source == rhs.source && lhs.destination == rhs.destination
        let sameButOpposite = lhs.source == rhs.destination && lhs.destination == rhs.source
        return sameSourceAndDest || sameButOpposite
    }
}

extension BacklinkEdge: Codable {}
