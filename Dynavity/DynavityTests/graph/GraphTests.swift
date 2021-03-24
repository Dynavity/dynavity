import XCTest
@testable import Dynavity

class GraphTests: XCTestCase {
    var undirectedGraph: Graph<Character>!
    var directedGraph: Graph<Character>!
    var node1 = Node<Character>("A")
    var node2 = Node<Character>("B")
    var node3 = Node<Character>("C")
    var node4 = Node<Character>("D")
    var node5 = Node<Character>("E")
    var node6 = Node<Character>("F")

    override func setUpWithError() throws {
        try super.setUpWithError()
        undirectedGraph = Graph(isDirected: false)
        directedGraph = Graph(isDirected: true)
    }

    override func tearDownWithError() throws {
        undirectedGraph = nil
        directedGraph = nil
        try super.tearDownWithError()
    }

    private func initGraphsWithNode1() {
        undirectedGraph.addNode(node1)
        directedGraph.addNode(node1)
    }

    private func initSampleUndirectedGraph() {
        let edge1 = Edge(source: node1, destination: node2)
        let edge2 = Edge(source: node1, destination: node3)
        let edge3 = Edge(source: node1, destination: node4)
        let edge4 = Edge(source: node3, destination: node5)
        let edges = [edge1, edge2, edge3, edge4]

        for edge in edges {
            undirectedGraph.addEdge(edge)
        }
        undirectedGraph.addNode(node6)
    }

    private func initSampleDirectedGraph() {
        let edge1 = Edge(source: node1, destination: node2)
        let edge2 = Edge(source: node1, destination: node3)
        let edge3 = Edge(source: node1, destination: node4)
        let edge4 = Edge(source: node3, destination: node5)
        let edge5 = Edge(source: node5, destination: node4)
        let edges = [edge1, edge2, edge3, edge4, edge5]

        for edge in edges {
            directedGraph.addEdge(edge)
        }
    }

    func testConstruct() {
        XCTAssertFalse(undirectedGraph.isDirected)
        XCTAssertTrue(directedGraph.isDirected)
    }

    func testNodes() {
        let nodes = [node1, node2, node3]
        for node in nodes {
            undirectedGraph.addNode(node)
            directedGraph.addNode(node)
        }

        // Add the same node again to check that there's no duplicate
        undirectedGraph.addNode(node2)
        directedGraph.addNode(node2)

        XCTAssertEqual(Set(undirectedGraph.nodes), Set(nodes))
        XCTAssertEqual(Set(directedGraph.nodes), Set(nodes))
    }

    func testEdges() {
        let edge1 = Edge(source: node1, destination: node2, weight: 0.5)
        let edge2 = Edge(source: node2, destination: node1, weight: 1.2)
        let edge3 = Edge(source: node1, destination: node2, weight: 0.6)
        let edge4 = Edge(source: node3, destination: node1, weight: 0.1)
        for edge in [edge1, edge2, edge3, edge4] {
            undirectedGraph.addEdge(edge)
            directedGraph.addEdge(edge)
        }

        // Add the same edge again to check that there's no duplicate
        undirectedGraph.addEdge(edge2)
        directedGraph.addEdge(edge2)

        XCTAssertEqual(Set(undirectedGraph.edges), Set([edge1, edge1.reverse(),
                                                        edge2, edge2.reverse(),
                                                        edge3, edge3.reverse(),
                                                        edge4, edge4.reverse()]))
        XCTAssertEqual(Set(directedGraph.edges), Set([edge1, edge2, edge3, edge4]))
    }

    func testAddNode_nodeDoesNotYetExist() {
        initGraphsWithNode1()

        XCTAssertTrue(undirectedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.containsNode(node1))
    }

    func testAddNode_nodeAlreadyExists() {
        initGraphsWithNode1()

        // Should not add node that already exists
        undirectedGraph.addNode(node1)
        directedGraph.addNode(node1)

        // Should not add node with identical label
        let sameLabelNode = Node(node1.label)
        undirectedGraph.addNode(sameLabelNode)
        directedGraph.addNode(sameLabelNode)

        XCTAssertTrue(undirectedGraph.containsNode(node1))
        XCTAssertTrue(undirectedGraph.nodes.count == 1)
        XCTAssertTrue(directedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.nodes.count == 1)
    }

    func testRemoveNode_nodeDoesNotExist() {
        undirectedGraph.removeNode(node1)
        directedGraph.removeNode(node1)

        XCTAssertFalse(undirectedGraph.containsNode(node1))
        XCTAssertTrue(undirectedGraph.nodes.isEmpty)
        XCTAssertFalse(directedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.nodes.isEmpty)
    }

    func testRemoveNode_nodeExists() {
        initGraphsWithNode1()

        undirectedGraph.removeNode(node1)
        directedGraph.removeNode(node1)

        XCTAssertFalse(undirectedGraph.containsNode(node1))
        XCTAssertTrue(undirectedGraph.nodes.isEmpty)
        XCTAssertFalse(directedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.nodes.isEmpty)
    }

    func testRemoveNode_allReferencedEdgesRemoved() {
        let edge = Edge(source: node1, destination: node2)
        // Set up
        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        undirectedGraph.removeNode(node1)
        directedGraph.removeNode(node1)

        XCTAssertTrue(undirectedGraph.edges.isEmpty)
        XCTAssertTrue(directedGraph.edges.isEmpty)
    }

    func testContainsNode() {
        XCTAssertFalse(undirectedGraph.containsNode(node1))
        XCTAssertFalse(directedGraph.containsNode(node1))

        initGraphsWithNode1()

        XCTAssertTrue(undirectedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.containsNode(node1))
    }

    func testAddEdge_edgeDoesNotYetExistAndNodesDoNotExist() {
        let edge = Edge(source: node1, destination: node2)

        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        XCTAssertTrue(undirectedGraph.containsNode(node1))
        XCTAssertTrue(undirectedGraph.containsNode(node2))
        XCTAssertTrue(undirectedGraph.containsEdge(edge))
        XCTAssertTrue(undirectedGraph.containsEdge(edge.reverse()))
        XCTAssertTrue(directedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.containsNode(node2))
        XCTAssertTrue(directedGraph.containsEdge(edge))
    }

    func testAddEdge_edgeDoesNotYetExistAndNodesExist() {
        // Set up
        let edge = Edge(source: node1, destination: node2)
        initGraphsWithNode1()
        undirectedGraph.addNode(node2)
        directedGraph.addNode(node2)

        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        XCTAssertTrue(undirectedGraph.containsNode(node1))
        XCTAssertTrue(undirectedGraph.containsNode(node2))
        XCTAssertTrue(undirectedGraph.containsEdge(edge))
        XCTAssertTrue(undirectedGraph.containsEdge(edge.reverse()))
        XCTAssertTrue(directedGraph.containsNode(node1))
        XCTAssertTrue(directedGraph.containsNode(node2))
        XCTAssertTrue(directedGraph.containsEdge(edge))
    }

    func testAddEdge_edgeAlreadyExists() {
        let edge = Edge(source: node1, destination: node2)
        // Set up
        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        // Should not add edge that already exists
        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        XCTAssertTrue(undirectedGraph.containsEdge(edge))
        XCTAssertTrue(undirectedGraph.containsEdge(edge.reverse()))
        XCTAssertTrue(directedGraph.containsEdge(edge))
    }

    func testRemoveEdge_edgeDoesNotExist() {
        let edge = Edge(source: node1, destination: node2)

        undirectedGraph.removeEdge(edge)
        directedGraph.removeEdge(edge)

        XCTAssertTrue(undirectedGraph.edges.isEmpty)
        XCTAssertTrue(directedGraph.edges.isEmpty)
    }

    func testRemoveEdge_edgeExists() {
        let edge = Edge(source: node1, destination: node2)
        // Set up
        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        undirectedGraph.removeEdge(edge)
        directedGraph.removeEdge(edge)

        XCTAssertFalse(undirectedGraph.containsEdge(edge))
        XCTAssertFalse(undirectedGraph.containsEdge(edge.reverse()))
        XCTAssertFalse(directedGraph.containsEdge(edge))
    }

    func testContainsEdge() {
        let edge = Edge(source: node1, destination: node2)

        XCTAssertFalse(undirectedGraph.containsEdge(edge))
        XCTAssertFalse(undirectedGraph.containsEdge(edge.reverse()))
        XCTAssertFalse(directedGraph.containsEdge(edge))

        undirectedGraph.addEdge(edge)
        directedGraph.addEdge(edge)

        XCTAssertTrue(undirectedGraph.containsEdge(edge))
        XCTAssertTrue(undirectedGraph.containsEdge(edge.reverse()))
        XCTAssertTrue(directedGraph.containsEdge(edge))
    }

    func testAdjacentNodesFromNode_requestedNodeExists() {
        let edge1 = Edge(source: node1, destination: node2, weight: 0.5)
        let edge2 = Edge(source: node2, destination: node3, weight: 1.2)
        let edge3 = Edge(source: node1, destination: node2, weight: 0.6)
        let edges = [edge1, edge2, edge3]
        // Set up
        for edge in edges {
            undirectedGraph.addEdge(edge)
            directedGraph.addEdge(edge)
        }

        XCTAssertEqual(Set(undirectedGraph.adjacentNodesFromNode(node2)), Set([node1, node3]))
        XCTAssertEqual(Set(directedGraph.adjacentNodesFromNode(node2)), Set([node3]))
    }

    func testAdjacentNodesFromNode_requestedNodeDoesNotExist() {
        let edge1 = Edge(source: node1, destination: node2, weight: 0.5)
        let edge2 = Edge(source: node2, destination: node1, weight: 1.2)
        let edge3 = Edge(source: node1, destination: node2, weight: 0.6)
        // Set up
        for edge in [edge1, edge2, edge3] {
            undirectedGraph.addEdge(edge)
            directedGraph.addEdge(edge)
        }

        XCTAssertEqual(Set(undirectedGraph.adjacentNodesFromNode(node3)), Set())
        XCTAssertEqual(Set(directedGraph.adjacentNodesFromNode(node3)), Set())
    }
}
