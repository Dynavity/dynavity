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

    func extrudePoint(target: UmlElementProtocol, _ anchor: ConnectorConnectingSide) -> CGPoint {
        switch anchor {
        case .middleLeft:
            // Account for shape margin as points in graph will have taken into account the margin
            return CGPoint(x: target.position.x - (target.width / 2) - shapeMargin,
                           y: target.position.y)
        case .middleRight:
            return CGPoint(x: target.position.x + (target.width / 2) + shapeMargin,
                           y: target.position.y)
        case .middleBottom:
            return CGPoint(x: target.position.x,
                           y: target.position.y + (target.height / 2) + shapeMargin)
        case .middleTop:
            return CGPoint(x: target.position.x,
                           y: target.position.y - (target.height / 2) - shapeMargin)
        }
    }

    private func isConnectingSideVertical(side: ConnectorConnectingSide) -> Bool {
        side == .middleBottom || side == .middleTop
    }

    func drawRulers(connectingSide: ConnectorConnectingSide) {
        let fromTop = fromElement.position.y - (fromElement.height / 2) - shapeMargin
        let fromBottom = fromElement.position.y + (fromElement.height / 2) + shapeMargin
        let toTop = toElement.position.y - (toElement.height / 2) - shapeMargin
        let toBottom = toElement.position.y + (toElement.height / 2) + shapeMargin
        // Used to generate possible destination for UmlConnector
        let toHorizontalMiddle = toElement.position.y
        horizontalRulers = [fromTop, fromBottom, toTop, toBottom, toHorizontalMiddle]

        let fromRight = fromElement.position.x + (fromElement.width / 2) + shapeMargin
        let fromLeft = fromElement.position.x - (fromElement.width / 2) - shapeMargin
        let toRight = toElement.position.x + (toElement.width / 2) + shapeMargin
        let toLeft = toElement.position.x - (toElement.width / 2) - shapeMargin
        // Used to generate possible destination for UmlConnector
        let toVerticalMiddle = toElement.position.x
        verticalRulers = [fromRight, fromLeft, toRight, toLeft, toVerticalMiddle]

        if isConnectingSideVertical(side: connectingSide) {
            verticalRulers.append(fromElement.position.x)
        } else {
            horizontalRulers.append(fromElement.position.y)
        }
        verticalRulers.sort()
        horizontalRulers.sort()
    }

    func generateGridFromRulers(gridBounds: GridRectangle) -> Grid {
        let grid = Grid()
        var lastX = gridBounds.leftEdge
        var lastY = gridBounds.topEdge
        var column = 0
        var row = 0

        for y in horizontalRulers {
            for x in verticalRulers {
                grid.set(row: row,
                         col: column,
                         rectangle: GridRectangle.fromLTRB(left: lastX, top: lastY, right: x, bottom: y))
                column += 1
                lastX = x
            }

            grid.set(row: row,
                     col: column,
                     rectangle: GridRectangle.fromLTRB(left: lastX, top: lastY, right: gridBounds.rightEdge, bottom: y))
            lastX = gridBounds.leftEdge
            lastY = y
            column = 0
            row += 1
        }

        lastX = gridBounds.leftEdge

        // Last row of cells
        for x in verticalRulers {
            grid.set(row: row,
                     col: column,
                     rectangle: GridRectangle.fromLTRB(left: lastX,
                                                       top: lastY,
                                                       right: x,
                                                       bottom: gridBounds.bottomEdge))
            column += 1
            lastX = x
        }
        // Last cell of last row
        grid.set(row: row,
                 col: column,
                 rectangle: GridRectangle.fromLTRB(left: lastX,
                                                   top: lastY,
                                                   right: gridBounds.rightEdge,
                                                   bottom: gridBounds.bottomEdge))

        return grid
    }

    // The points generated doesn't take into account obstacles(other UmlElementProtocols) in the grid
    func generateGridPoints(_ grid: Grid) -> [CGPoint] {
        var gridPoints: [CGPoint] = []

        for (row, dict) in grid.rectangles {
            let isFirstRow = row == 0
            let isLastRow = row == grid.rows - 1

            for (col, rectangle) in dict {
                let isFirstCol = col == 0
                let isLastCol = col == grid.cols - 1
                let isTopLeft = isFirstRow && isFirstCol
                let isTopRight = isFirstRow && isLastCol
                let isBottomLeft = isLastRow && isFirstCol
                let isBottomRight = isLastRow && isLastCol

                // Add various reference points depending on position of rectangle on grid
                if isTopLeft || isTopRight || isBottomLeft || isBottomRight {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint, rectangle.topRightPoint,
                                                   rectangle.bottomLeftPoint, rectangle.bottomRightPoint])
                } else if isFirstRow {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint, rectangle.topPoint, rectangle.topRightPoint])
                } else if isLastRow {
                    gridPoints.append(contentsOf: [rectangle.bottomRightPoint,
                                                   rectangle.bottomPoint,
                                                   rectangle.bottomLeftPoint])
                } else if isFirstCol {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint,
                                                   rectangle.leftPoint,
                                                   rectangle.bottomLeftPoint])
                } else if isLastCol {
                    gridPoints.append(contentsOf: [rectangle.topRightPoint,
                                                   rectangle.rightPoint,
                                                   rectangle.bottomRightPoint])
                } else {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint, rectangle.topPoint,
                                                   rectangle.topRightPoint, rectangle.rightPoint,
                                                   rectangle.bottomRightPoint, rectangle.bottomPoint,
                                                   rectangle.bottomLeftPoint, rectangle.leftPoint,
                                                   rectangle.center])
                }
            }
        }

        return gridPoints.uniqued()
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

    func isChangingDirection(_ comingDirection: PathDirection?, _ goingDirection: PathDirection?) -> Bool {
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
        GridRectangle.fromLTRB(left: min(fromElement.position.x - (fromElement.width / 2) - boundsMargin,
                                         toElement.position.x - (toElement.width / 2) - boundsMargin),
                               top: min(fromElement.position.y - (fromElement.height / 2) - boundsMargin,
                                        toElement.position.y - (toElement.height / 2) - boundsMargin),
                               right: max(fromElement.position.x + (fromElement.width / 2) + boundsMargin,
                                          toElement.position.x + (toElement.width / 2) + boundsMargin),
                               bottom: max(fromElement.position.y + (fromElement.height / 2) + boundsMargin,
                                           toElement.position.y + (toElement.height / 2) + boundsMargin))
    }

    // TODO: destAnchor currently unused, factor that in to the endpoint of the SP algo
    func generateRoute(_ anchor: ConnectorConnectingSide, destAnchor: ConnectorConnectingSide) -> [CGPoint] {
        let bounds = getGridBounds()
        drawRulers(connectingSide: anchor)
        let grid = generateGridFromRulers(gridBounds: bounds)
        let gridPoints = generateGridPoints(grid)
        let graph = createGraph(points: gridPoints)
        let extrudedSource = extrudePoint(target: fromElement, anchor)
        let extrudedDest = extrudePoint(target: toElement, destAnchor)
        let path = shortestPath(graph: graph, source: extrudedSource, destination: extrudedDest)
        return path
    }
}
