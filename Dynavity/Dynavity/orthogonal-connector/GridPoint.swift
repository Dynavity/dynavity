import CoreGraphics

/**
 Encapsulates a point in the grid used in `OrthogonalConnector`.
 
 This is used as part of the algorithm to find the orthogonal diagram connector routing between UmlElements.
 */
class GridPoint: Hashable {
    static func == (lhs: GridPoint, rhs: GridPoint) -> Bool {
        lhs.point == rhs.point
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(point)
    }

    let point: CGPoint

    // For shortest path calculations
    var pathLengthFromSource = Double.infinity
    var pathNodesFromSource: [GridPoint] = []

    init(point: CGPoint) {
        self.point = point
    }
}
