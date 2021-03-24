/**
 `Edge` represents an edge in a graph. An `Edge` is associated with a source
 `Node`, a destination `Node` and a weight. This means that
 `Edge` is a directed edge from the source to the destination.

 Similar to `Node`, `Edge` is a generic type with a type parameter `T` that is
 the type of a node's label.
 */
struct Edge<T: Hashable> {
    let source: Node<T>
    let destination: Node<T>
    let weight: Double

    /// Constructs an `Edge` from `source` to `destination` with the
    /// default weight of 1.0.
    /// - Parameters
    ///   - source: The source `Node`
    ///   - destination: The destination `Node`
    init(source: Node<T>, destination: Node<T>) {
        self.init(source: source, destination: destination, weight: 1.0)
    }

    /// Constructs an `Edge` from `source` to `destination` with the
    /// cost of `weight`.
    /// - Parameters
    ///   - source: The source `Node`
    ///   - destination: The destination `Node`
    ///   - weight: The weight of the `Edge`
    init(source: Node<T>, destination: Node<T>, weight: Double) {
        self.source = source
        self.destination = destination
        self.weight = weight
    }

    /// Returns an edge in the opposite direction with the same cost.
    func reverse() -> Edge<T> {
        Edge(source: destination, destination: source, weight: weight)
    }
}

// MARK: Hashable
extension Edge: Hashable {}
