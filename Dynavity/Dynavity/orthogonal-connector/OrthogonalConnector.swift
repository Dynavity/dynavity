import CoreGraphics

/**
 Responsible for routing orthogonal diagram connectors for UML diagramming feature.
    - Returns the path for an orthogonal connector, given two shapes and their connection points.
 
 Credits to https://medium.com/swlh/routing-orthogonal-diagram-connectors-in-javascript-191dc2c5ff70 for
 algorithm inspiration.

 Invariants:
    - Grid formed in OrthogonalConnector must contain the source and destination `UmlElementProtocol`
    - 
 */
class OrthogonalConnector {
    // Used in shortest path calculation to punish change in direction
    enum PathDirection {
        case vertical
        case horizontal
    }

    let shapeMargin: CGFloat = 10.0
    let boundsMargin: CGFloat = 20.0
    var verticalRulers: [CGFloat] = []
    var horizontalRulers: [CGFloat] = []
    private let fromElement: UmlElementProtocol
    private let toElement: UmlElementProtocol

    init(from: UmlElementProtocol, to: UmlElementProtocol) {
        fromElement = from
        toElement = to
    }

    private func pointAtTopSide(target: UmlElementProtocol, point: CGPoint) -> Bool {
        let topThresholdBuffer: CGFloat = target.height / 10
        let topThreshold = target.position.y - (target.height / 2) + topThresholdBuffer
        return point.y <= topThreshold
    }

    private func pointAtBottomSide(target: UmlElementProtocol, point: CGPoint) -> Bool {
        let bottomThresholdBuffer: CGFloat = target.height / 10
        let bottomThreshold = target.position.y + (target.height / 2) - bottomThresholdBuffer
        return point.y >= bottomThreshold
    }

    private func pointAtLeftSide(target: UmlElementProtocol, point: CGPoint) -> Bool {
        let leftThresholdBuffer: CGFloat = target.width / 10
        let leftThreshold = target.position.x - (target.width / 2) + leftThresholdBuffer
        return point.x <= leftThreshold
    }

    private func pointAtRightSide(target: UmlElementProtocol, point: CGPoint) -> Bool {
        let rightThresholdBuffer: CGFloat = target.width / 10
        let rightThreshold = target.position.x + (target.width / 2) - rightThresholdBuffer
        return point.x >= rightThreshold
    }

    func generatePoint(target: UmlElementProtocol, _ anchor: ConnectorConnectingSide) -> CGPoint {
        var point: CGPoint
        switch anchor {
        case .middleLeft:
            // Account for shape margin as points in graph will have taken into account the margin
            point = CGPoint(x: (target.topLeftCorner.x + target.bottomLeftCorner.x) / 2,
                            y: (target.topLeftCorner.y + target.bottomLeftCorner.y) / 2)
        case .middleRight:
            point = CGPoint(x: (target.topRightCorner.x + target.bottomRightCorner.x) / 2,
                            y: (target.topRightCorner.y + target.bottomRightCorner.y) / 2)
        case .middleBottom:
            point = CGPoint(x: (target.bottomLeftCorner.x + target.bottomRightCorner.x) / 2,
                            y: (target.bottomLeftCorner.y + target.bottomRightCorner.y) / 2)
        case .middleTop:
            point = CGPoint(x: (target.topLeftCorner.x + target.topRightCorner.x) / 2,
                            y: (target.topLeftCorner.y + target.topRightCorner.y) / 2)
        }
        point.x = point.x.rounded()
        point.y = point.y.rounded()

        return point
    }

    private func isConnectingSideVertical(target: UmlElementProtocol, connectingPoint: CGPoint) -> Bool {
        pointAtTopSide(target: target, point: connectingPoint)
        || pointAtBottomSide(target: target, point: connectingPoint)
    }

    func drawRulers(connectingSide: ConnectorConnectingSide, destConnectingSide: ConnectorConnectingSide) {
        let fromTop = fromElement.topMostPoint.y.rounded() - shapeMargin
        let fromBottom = fromElement.bottomMostPoint.y.rounded() + shapeMargin
        let toTop = toElement.topMostPoint.y.rounded() - shapeMargin
        let toBottom = toElement.bottomMostPoint.y.rounded() + shapeMargin
        horizontalRulers = [fromTop, fromBottom, toTop, toBottom]

        let fromRight = fromElement.rightMostPoint.x.rounded() + shapeMargin
        let fromLeft = fromElement.leftMostPoint.x.rounded() - shapeMargin
        let toRight = toElement.rightMostPoint.x.rounded() + shapeMargin
        let toLeft = toElement.leftMostPoint.x.rounded() - shapeMargin
        verticalRulers = [fromRight, fromLeft, toRight, toLeft]

        // Add ruler for source connecting side
        let sourceConnectingPoint = generatePoint(target: fromElement, connectingSide)
        if isConnectingSideVertical(target: fromElement, connectingPoint: sourceConnectingPoint) {
            verticalRulers.append(sourceConnectingPoint.x)
        } else {
            horizontalRulers.append(sourceConnectingPoint.y)
        }

        // Add ruler for destination connecting side
        let destConnectingPoint = generatePoint(target: toElement, destConnectingSide)
        if isConnectingSideVertical(target: toElement, connectingPoint: destConnectingPoint) {
            verticalRulers.append(destConnectingPoint.x)
        } else {
            horizontalRulers.append(destConnectingPoint.y)
        }
        verticalRulers.sort()
        horizontalRulers.sort()
    }

    /**
     Create graph using the reference points from the grid created in `generateGridPoints`, connecting reference points
     orthogonally.
     */
    func createGraph(points: [CGPoint]) -> Graph<GridPoint> {
        var graph = Graph<GridPoint>(isDirected: false)
        var xCoordinates: [CGFloat] = []
        var yCoordinates: [CGFloat] = []

        // Populate graph with nodes
        points.forEach {
            if !xCoordinates.contains($0.x) {
                xCoordinates.append($0.x)
            }
            if !yCoordinates.contains($0.y) {
                yCoordinates.append($0.y)
            }
            graph.addNode(Node(GridPoint(point: $0)))
        }
        xCoordinates.sort()
        yCoordinates.sort()

        // Draw bidirectional orthogonal connections between points in the graph
        for (i, xCoordinate) in xCoordinates.enumerated() {
            for (j, yCoordinate) in yCoordinates.enumerated() {
                let firstNode = Node(GridPoint(point: CGPoint(x: xCoordinate, y: yCoordinate)))

                if !graph.containsNode(firstNode) {
                    continue
                }

                if i > 0 {
                    let leftNodeOnGrid = Node(GridPoint(point: CGPoint(x: xCoordinates[i - 1], y: yCoordinate)))
                    if graph.containsNode(leftNodeOnGrid) {
                        let edge = Edge(source: firstNode, destination: leftNodeOnGrid,
                                        weight: Double(firstNode.label.point.x - leftNodeOnGrid.label.point.x))
                        graph.addEdge(edge)
                    }
                }

                if j > 0 {
                    let topNodeOnGrid = Node(GridPoint(point: CGPoint(x: xCoordinate, y: yCoordinates[j - 1])))
                    if graph.containsNode(topNodeOnGrid) {
                        let edge = Edge(source: firstNode, destination: topNodeOnGrid,
                                        weight: Double(firstNode.label.point.y - topNodeOnGrid.label.point.y))
                        graph.addEdge(edge)
                    }
                }
            }
        }
        return graph
    }

    func getDirectionOfNodes(source: GridPoint, destination: GridPoint) -> PathDirection? {
        if source.point.x == destination.point.x {
            return .vertical
        } else if source.point.y == destination.point.y {
            return .horizontal
        } else {
            return nil
        }
    }

    func getCurrPathDirection(_ node: Node<GridPoint>) -> PathDirection? {
        if node.label.pathNodesFromSource.isEmpty {
            // No direction change
            return nil
        }
        let shortestPath = node.label.pathNodesFromSource
        return getDirectionOfNodes(source: shortestPath[shortestPath.count - 1], destination: node.label)
    }

    private func isChangingDirection(_ comingDirection: PathDirection?, _ goingDirection: PathDirection?) -> Bool {
        guard let comingDirection = comingDirection,
              let goingDirection = goingDirection else {
            return false
        }
        return comingDirection != goingDirection
    }

    /**
     Shortest path algorithm punishes change in direction to prevent creation of "staircase" lines
     */
    func calculateNewWeight(_ source: Node<GridPoint>, _ destination: Node<GridPoint>,
                            _ currentWeight: Double) -> Double {
        let directionChangeCost = pow(currentWeight + 1, 2)

        let distanceFromSource = source.label.pathLengthFromSource
        let comingDirection = getCurrPathDirection(source)
        let goingDirection = getDirectionOfNodes(source: source.label, destination: destination.label)
        let extraWeight = isChangingDirection(comingDirection, goingDirection) ? directionChangeCost : 0

        return distanceFromSource + currentWeight + extraWeight
    }

    // Modified Dijkstra algorithm
    func shortestPath(graph: Graph<GridPoint>, source: CGPoint, destination: CGPoint) -> [CGPoint] {
        let sourceNode = Node(GridPoint(point: source))
        var destinationNode = Node(GridPoint(point: destination))
        var currentNode: Node<GridPoint>? = graph.getNode(sourceNode)
        currentNode?.label.pathLengthFromSource = 0
        currentNode?.label.pathNodesFromSource.append(sourceNode.label)
        var unvisitedNodes = Set(graph.nodes)

        while let node = currentNode {
            if unvisitedNodes.isEmpty {
                currentNode = nil
                break
            }
            unvisitedNodes.remove(node)

            let adjacentNodes = graph.adjacentNodesFromNode(node)
            let unvisitedNeighbours = adjacentNodes.filter { unvisitedNodes.contains($0) }
            for neighbour in unvisitedNeighbours {
                let weight = graph.getEdgeBetween(source: node, destination: neighbour)?.weight
                let theoreticNewWeight = calculateNewWeight(node, neighbour, weight ?? 1)

                if theoreticNewWeight < neighbour.label.pathLengthFromSource {
                    neighbour.label.pathLengthFromSource = theoreticNewWeight
                    var currShortestPath = node.label.pathNodesFromSource
                    currShortestPath.append(neighbour.label)
                    neighbour.label.pathNodesFromSource = currShortestPath
                    unvisitedNodes.update(with: neighbour)
                    destinationNode = neighbour == destinationNode ? neighbour : destinationNode
                }
            }

            currentNode = unvisitedNodes.min { $0.label.pathLengthFromSource < $1.label.pathLengthFromSource }
        }
        return destinationNode.label.pathNodesFromSource.map { $0.point }
    }

    func getGridBounds() -> GridRectangle {
        GridRectangle.fromLTRB(left: min(fromElement.leftMostPoint.x - boundsMargin,
                                         toElement.leftMostPoint.x - boundsMargin),
                               top: min(fromElement.topMostPoint.y - boundsMargin,
                                        toElement.topMostPoint.y - boundsMargin),
                               right: max(fromElement.rightMostPoint.x + boundsMargin,
                                          toElement.rightMostPoint.x + boundsMargin),
                               bottom: max(fromElement.bottomMostPoint.y + boundsMargin,
                                           toElement.bottomMostPoint.y + boundsMargin))
    }

    private func getNearestCoordinate(coordinate: CGFloat, ruler: [CGFloat]) -> CGFloat {
        var minDist: CGFloat = .infinity
        var nearestCoordinate = coordinate
        for value in ruler {
            let dist = abs(coordinate - value)
            if dist < minDist {
                minDist = dist
                nearestCoordinate = value
            }
        }
        return nearestCoordinate
    }

    private func getPointInGraph(target: UmlElementProtocol, point: CGPoint) -> CGPoint {
        var updatedPoint = point
        if isConnectingSideVertical(target: target, connectingPoint: point) {
            let nearestYCoordinate = getNearestCoordinate(coordinate: point.y, ruler: horizontalRulers)
            updatedPoint.y = nearestYCoordinate
        } else {
            let nearestXCoordinate = getNearestCoordinate(coordinate: point.x, ruler: verticalRulers)
            updatedPoint.x = nearestXCoordinate
        }

        return updatedPoint
    }

    func generateRoute(_ anchor: ConnectorConnectingSide, destAnchor: ConnectorConnectingSide) -> [CGPoint] {
        let bounds = getGridBounds()
        drawRulers(connectingSide: anchor, destConnectingSide: destAnchor)
        let grid = Grid.generateGridFromRulers(gridBounds: bounds,
                                               horizontalRulers: horizontalRulers,
                                               verticalRulers: verticalRulers)
        let gridPoints = grid.generateGridPoints(fromElement: fromElement, toElement: toElement)
        let graph = createGraph(points: gridPoints)
        let source = generatePoint(target: fromElement, anchor)
        let dest = generatePoint(target: toElement, destAnchor)
        let sourceInGraph = getPointInGraph(target: fromElement, point: source)
        let destInGraph = getPointInGraph(target: toElement, point: dest)
        var route: [CGPoint] = [source]
        route.append(contentsOf: shortestPath(graph: graph, source: sourceInGraph, destination: destInGraph))
        route.append(dest)
        return route
    }
}
