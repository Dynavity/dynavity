/**
 `Graph` is able to represent the following graph types with
 corresponding constraints:
 - Undirected graph
   + An undirected edge is represented by 2 directed edges
 - Directed graph
 - Simple graph
 - Unweighted graph
   + Edges' weights are to set to 1.0
 - Weighted graph

 `Graph` is not able to represent the following graph types:
 - Multigraph

For every Graph g:
 - g is either directed or undirected
 - All nodes in g must have unique labels

 Similar to `Node` and `Edge`, `Graph` is a generic type with a type parameter
 `T` that defines the type of the nodes' labels.
 */
struct Graph<T: Hashable> {
    private let isDirected: Bool

    // Keep track of this to be able to use the most appropriate algorithms for the graph
    private var hasNegativeWeights: Bool
    private var adjList: [Node<T>: Set<Edge<T>>] = [:]

    /// A read-only computed property that contains all the nodes
    /// of the graphs.
    private var nodes: [Node<T>] {
        Array(adjList.keys)
    }

    /// A read-only computed property that contains all the edges
    /// of the graphs.
    private var edges: [Edge<T>] {
        Array(adjList.values.flatMap({ $0 }))
    }

    /// Constructs a directed or undirected graph.
    init(isDirected: Bool) {
        self.isDirected = isDirected
        self.hasNegativeWeights = false
    }

    /// Adds the given node to the graph.
    /// If the node already exists in the graph, do nothing.
    private mutating func addNode(_ addedNode: Node<T>) {
        if !containsNode(addedNode) {
            adjList[addedNode] = []
        }

        assert(checkRepresentation())
    }

    /// Remove the given node from the graph.
    /// If the node does not exist in the graph, do nothing.
    private mutating func removeNode(_ removedNode: Node<T>) {
        if !containsNode(removedNode) {
            return
        }

        // Remove node and all edges starting from removedNode
        adjList.removeValue(forKey: removedNode)

        // Remove all edges ending at removedNode
        for (node, edges) in adjList {
            let remainingEdges = edges.filter({ $0.destination != removedNode })
            adjList[node] = remainingEdges
        }

        assert(checkRepresentation())
    }

    /// Whether the graph contains the requested node.
    /// - Returns: true if the node exists in the graph
    private func containsNode(_ targetNode: Node<T>) -> Bool {
        adjList[targetNode] != nil
    }

    /// Adds the given edge to the graph.
    /// If the edge already exists, do nothing. If any of the nodes referenced
    /// in the edge does not exist, it is added to the graph.
    private mutating func addEdge(_ addedEdge: Edge<T>) {
        let destNode = addedEdge.destination
        let srcNode = addedEdge.source

        // Add nodes referenced in edges which does not exist
        if !containsNode(destNode) {
            adjList[destNode] = []
        }
        if !containsNode(srcNode) {
            adjList[srcNode] = []
        }

        adjList[srcNode]?.insert(addedEdge)
        if !isDirected {
            adjList[destNode]?.insert(addedEdge.reverse())
        }

        assert(checkRepresentation())
    }

    /// Removes the requested edge from the graph. If it does not exist, do
    /// nothing.
    private mutating func removeEdge(_ removedEdge: Edge<T>) {
        let srcNode = removedEdge.source

        if containsEdge(removedEdge) {
            adjList[srcNode]?.remove(removedEdge)
        }

        let reversed = removedEdge.reverse()
        if !isDirected && containsEdge(reversed) {
            adjList[reversed.source]?.remove(reversed)
        }

        assert(checkRepresentation())
    }

    /// Whether the requested edge exists in the graph.
    /// - Returns: true if the requested edge exists.
    private func containsEdge(_ targetEdge: Edge<T>) -> Bool {
        let srcNode = targetEdge.source

        if !containsNode(srcNode) {
            // Edge definitely does not exist
            return false
        }

        guard let edgesFromSrcNode = adjList[srcNode] else {
            assertionFailure("containNodes should have already checked for nil")
            return false
        }

        return edgesFromSrcNode.contains(targetEdge)
    }

    /// Returns adjacent nodes of the `fromNode`, i.e. there is a directed edge
    /// from `fromNode` to its adjacent node. If the requested node does not
    /// exist, returns an empty array.
    /// - Parameters:
    ///   - fromNode: the source `Node`
    /// - Returns: an array of adjacent `Node`s
    private func adjacentNodesFromNode(_ fromNode: Node<T>) -> [Node<T>] {
        if !containsNode(fromNode) {
            return []
        }

        guard let edgesFromNode = adjList[fromNode] else {
            assertionFailure("containNodes should have already checked for nil")
            return []
        }

        let requiredNodes = edgesFromNode.map({ $0.destination })

        return Array(requiredNodes)
    }

    /// Checks that the directed/undirected invariant of the graph is not violated.
    /// Specifically, for an undirected graph, for every edge from node `src` to node `dest`,
    /// there should be a corresponding edge from `dest` to `src` with the same weight.
    private func checkDirectedUndirectedInvariant() -> Bool {
        // A directed graph trivially does not violate this invariant
        if isDirected {
            return true
        }

        let allEdges = edges

        // Number of edges should be even for undirected graph
        if !allEdges.count.isMultiple(of: 2) {
            return false
        }

        for i in allEdges.indices {
            let currentEdge = allEdges[i]
            let oppositeEdge = currentEdge.reverse()

            if !allEdges.contains(oppositeEdge) {
                return false
            }
        }

        return true
    }

    /// Checks that every node has a unique label in the graph
    private func hasUniqueLabelsOnNodes() -> Bool {
        let numberOfNodes = nodes.count
        let numberOfUniqueLabels = Set(nodes.map({ $0.label })).count
        return numberOfNodes == numberOfUniqueLabels
    }

    // For every edge in adjList[v] for some v, the edge y
    // For all nodes, u, in the graph, every edge in adjList[u] should have source node of u
    private func checkAdjancencyListImpl() -> Bool {
        for (node, edges) in adjList {
            for edge in edges where edge.source != node {
                return false
            }
        }
        return true
    }

    /// Checks the representation invariants.
    /// TODO: remember to disable this / ship app in production
    /// TODO: add another representation invariant that for every key in adjacency list,
    /// the edges must start from (key, someOtherDest)
    private func checkRepresentation() -> Bool {
        checkDirectedUndirectedInvariant()
            && hasUniqueLabelsOnNodes()
            && checkAdjancencyListImpl()
    }
}
