import Foundation

struct BacklinkEdge {
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

    /// Arbitrarliy hash the node that has a "smaller" name first.
    /// This is so that we conform to Hashable's requirement:
    /// Two instances that are equal must feed the same values to Hasher in hash(into:), in the same order.
    func hash(into hasher: inout Hasher) {
        let sourceName = source.name
        let destinationName = destination.name

        if sourceName <= destinationName {
            hasher.combine(source)
            hasher.combine(destination)
        } else {
            hasher.combine(destination)
            hasher.combine(source)
        }
    }
}
