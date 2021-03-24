/**
 `Node` represents a vertex in a graph. `Node` is a generic type with a type
 parameter `T` that is the type of the node's label. For example, `Node<String>`
 is the type of nodes with a `String` label and `Node<Int>` is the type of nodes
 with a `Int` Label.
 Because we need to compare the node label, the type parameter `T` needs to
 conform to `Hashable` protocol.
 */
struct Node<T: Hashable> {
    let label: T

    /// Creates a `Node` with the given `label`.
    init(_ label: T) {
        self.label = label
    }
}

// MARK: Hashable
extension Node: Hashable {}
