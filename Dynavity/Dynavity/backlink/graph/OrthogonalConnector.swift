import CoreGraphics

/**
 Responsible for routing orthogonal diagram connectors for UML diagramming feature.
    - Returns the path for an orthogonal connector, given two shapes and their connection points.
 
 Credits to https://medium.com/swlh/routing-orthogonal-diagram-connectors-in-javascript-191dc2c5ff70 for
 algorithm inspiration.
 */
class OrthogonalConnector {
    private class Grid {
        var rows: Int = 0
        var cols: Int = 0

        var rectangles: [Int: [Int: Rectangle]] = Dictionary()

        init() {}

        // Set a rectangle to a specefic row and column in the grid
        func set(row: Int, col: Int, rectangle: Rectangle) {
            rows = max(self.rows, row + 1)
            cols = max(self.cols, col + 1)

            var rowMap = rectangles[row]
            if rowMap == nil {
                rectangles.updateValue([Int: Rectangle](), forKey: row)
            }
            rowMap = rectangles[row]
            rowMap?.updateValue(rectangle, forKey: col)
        }

        func getRectangles() -> [Rectangle] {
            var gridRectangles: [Rectangle] = []

            for (_, dict) in rectangles {
                for (_, rectangle) in dict {
                    gridRectangles.append(rectangle)
                }
            }
            return gridRectangles
        }
    }

    private struct Rectangle {
        let width: CGFloat
        let height: CGFloat
        // X-coordinate left edge
        let leftEdge: CGFloat
        // Y-coordinate top edge
        let topEdge: CGFloat

        var center: CGPoint {
            CGPoint(x: leftEdge + (width / 2),
                    y: topEdge + (height / 2))
        }
        var rightEdge: CGFloat {
            leftEdge + width
        }
        var bottomEdge: CGFloat {
            topEdge + height
        }

        var topLeftPoint: CGPoint {
            CGPoint(x: leftEdge, y: topEdge)
        }
        var topRightPoint: CGPoint {
            CGPoint(x: rightEdge, y: topEdge)
        }
        var bottomLeftPoint: CGPoint {
            CGPoint(x: leftEdge, y: bottomEdge)
        }
        var bottomRightPoint: CGPoint {
            CGPoint(x: rightEdge, y: bottomEdge)
        }
        var topPoint: CGPoint {
            CGPoint(x: center.x, y: topEdge)
        }
        var bottomPoint: CGPoint {
            CGPoint(x: center.x, y: bottomEdge)
        }
        var leftPoint: CGPoint {
            CGPoint(x: leftEdge, y: center.y)
        }
        var rightPoint: CGPoint {
            CGPoint(x: rightEdge, y: center.y)
        }

        private init(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
            leftEdge = left
            topEdge = top
            self.width = width
            self.height = height
        }

        static func fromLTRB(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> Rectangle {
            Rectangle(left: left, top: top, width: right - left, height: bottom - top)
        }
    }

    enum ConnectingSide {
        // Can possibly add more connecting sides
        case middleLeft
        case middleRight
        case middleTop
        case middleBottom
    }

    // Used in shortest path calculation to punish change in direction
    enum PathDirection {
        case vertical
        case horizontal
    }
    
    private let fromElement: UmlElementProtocol
    private let toElement: UmlElementProtocol
    private let shapeMargin: CGFloat = 10.0
    private let boundsMargin: CGFloat = 20.0
    private var verticalRulers: [CGFloat] = []
    private var horizontalRulers: [CGFloat] = []

    init(from: UmlElementProtocol, to: UmlElementProtocol) {
        fromElement = from
        toElement = to
    }
    
    private func getSource(_ anchor: ConnectingSide) -> CGPoint {
        switch anchor {
        case .middleLeft:
            return CGPoint(x: fromElement.position.x - (fromElement.width / 2), y: fromElement.position.y)
        case .middleRight:
            return CGPoint(x: fromElement.position.x + (fromElement.width / 2), y: fromElement.position.y)
        case .middleBottom:
            return CGPoint(x: fromElement.position.x, y: fromElement.position.y + (fromElement.height / 2))
        case .middleTop:
            return CGPoint(x: fromElement.position.x, y: fromElement.position.y - (fromElement.height / 2))
        }
    }
    
    // TODO: Add logic to get destination based on drag gesture in `UmlSelectionOverlayView`
    private func getDestination() -> CGPoint {
        // TODO: Remove hardcoded destination on .middleLeft of the destination UmlElement
        return CGPoint(x: toElement.position.x - toElement.width / 2, y: toElement.position.y)
    }

    private func isConnectingSideVertical(side: ConnectingSide) -> Bool {
        side == .middleBottom || side == .middleTop
    }

    private func drawRulers(connectingSide: ConnectingSide) {
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

    private func generateGridFromRulers(gridBounds: Rectangle) -> Grid {
        let grid = Grid()
        var lastX = gridBounds.leftEdge
        var lastY = gridBounds.topEdge
        var column = 0
        var row = 0

        for y in horizontalRulers {
            for x in verticalRulers {
                column += 1
                grid.set(row: row,
                         col: column,
                         rectangle: Rectangle.fromLTRB(left: lastX, top: lastY, right: x, bottom: y))
                lastX = x
            }

            grid.set(row: row,
                     col: column,
                     rectangle: Rectangle.fromLTRB(left: lastX, top: lastY, right: gridBounds.rightEdge, bottom: y))
            lastX = gridBounds.leftEdge
            lastY = y
            column = 0
            row += 1
        }

        lastX = gridBounds.leftEdge

        // Last row of cells
        for x in verticalRulers {
            column += 1
            grid.set(row: row,
                     col: column,
                     rectangle: Rectangle.fromLTRB(left: lastX, top: lastY, right: x, bottom: gridBounds.bottomEdge))
            lastX = x
        }
        // Last cell of last row
        grid.set(row: row,
                 col: column,
                 rectangle: Rectangle.fromLTRB(left: lastX, top: lastY,
                                               right: gridBounds.rightEdge, bottom: gridBounds.bottomEdge))

        return grid
    }

    // The points generated doesn't take into account obstacles(other UmlElementProtocols) in the grid
    private func generateGridPoints(_ grid: Grid) -> [CGPoint] {
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
    private func createGraph(points: [CGPoint]) -> Graph<CGPoint> {
        var graph = Graph<CGPoint>(isDirected: false)
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
            graph.addNode(Node($0))
        }
        xCoordinates.sort()
        yCoordinates.sort()
        
        // Draw bidirectional orthogonal connections between points in the graph
        for (i, xCoordinate) in xCoordinates.enumerated() {
            for (j, yCoordinate) in yCoordinates.enumerated() {
                let firstNode = Node(CGPoint(x: xCoordinate, y: yCoordinate))
                
                if !graph.containsNode(firstNode) {
                    continue
                }
                
                if i > 0 {
                    let leftNodeOnGrid = Node(CGPoint(x: xCoordinates[i - 1], y: yCoordinate))
                    if graph.containsNode(leftNodeOnGrid) {
                        let edge = Edge(source: firstNode, destination: leftNodeOnGrid)
                        graph.addEdge(edge)
                    }
                }
                
                if j > 0 {
                    let topNodeOnGrid = Node(CGPoint(x: xCoordinate, y: yCoordinates[j - 1]))
                    if graph.containsNode(topNodeOnGrid) {
                        let edge = Edge(source: firstNode, destination: topNodeOnGrid)
                        graph.addEdge(edge)
                    }
                }
            }
        }
        return graph
    }
    
    private func getDirectionOfNodes(source: Node<CGPoint>, destination: Node<CGPoint>) -> PathDirection? {
        if (source.label.x == destination.label.x) {
            return .vertical
        } else if (source.label.y == destination.label.y) {
            return .horizontal
        } else {
            return nil
        }
    }
    
    private func getCurrPathDirection(_ node: Node<CGPoint>) -> PathDirection? {
        if (node.pathNodesFromSource.count == 0) {
            // No direction change
            return nil
        }
        let shortestPath = node.pathNodesFromSource
        return getDirectionOfNodes(source: shortestPath[shortestPath.count - 1], destination: node)
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
    private func calculateNewWeight(_ source: Node<CGPoint>, _ destination: Node<CGPoint>,
                                    _ currentWeight: Double) -> Double {
        let directionChangeCost = pow(currentWeight + 1, 2)
        
        let distanceFromSource = source.pathLengthFromSource
        let comingDirection = getCurrPathDirection(source)
        let goingDirection = getDirectionOfNodes(source: source, destination: destination)
        let extraWeight = isChangingDirection(comingDirection, goingDirection) ? directionChangeCost : 0
        
        return distanceFromSource + currentWeight + extraWeight
    }
    
    // Modified Dijkstra algorithm
    private func shortestPath(graph: Graph<CGPoint>, source: CGPoint, destination: CGPoint) -> [CGPoint] {
        let sourceNode = Node(source)
        var currentNode: Node<CGPoint>? = graph.getNode(sourceNode)
        currentNode?.pathLengthFromSource = 0
        currentNode?.pathNodesFromSource.append(sourceNode)
        var unvisitedNodes = Set(graph.nodes)
        
        while let node = currentNode {
            if unvisitedNodes.isEmpty {
                currentNode = nil
                break
            }
            
            unvisitedNodes.remove(node)
            let unvisitedNeighbours = graph.adjacentNodesFromNode(node).filter { unvisitedNodes.contains($0) }
            
            for var neighbour in unvisitedNeighbours {
                let weight = graph.getEdgeBetween(source: node, destination: neighbour)?.weight
                let theoreticNewWeight = calculateNewWeight(node, neighbour, weight ?? 0)
                
                if theoreticNewWeight < neighbour.pathLengthFromSource {
                    neighbour.pathLengthFromSource = theoreticNewWeight
                    neighbour.pathNodesFromSource.append(neighbour)
                }
            }

            currentNode = unvisitedNodes.min { $0.pathLengthFromSource < $1.pathLengthFromSource }
        }
        
        guard let shortestPath = graph.getNode(Node(destination))?.pathNodesFromSource else {
            return []
        }
        return shortestPath.map { $0.label }
    }

    func generateRoute(_ anchor: ConnectingSide) -> [CGPoint] {
        let bounds = Rectangle.fromLTRB(left: min(fromElement.position.x - (fromElement.width / 2) - boundsMargin,
                                                  toElement.position.x - (toElement.width / 2) - boundsMargin),
                                        top: min(fromElement.position.y - (fromElement.height / 2) - boundsMargin,
                                                 toElement.position.y - (toElement.height / 2) - boundsMargin),
                                        right: max(fromElement.position.x + (fromElement.width / 2) + boundsMargin,
                                                   toElement.position.x + (toElement.width / 2) + boundsMargin),
                                        bottom: max(fromElement.position.y + (fromElement.height / 2) + boundsMargin,
                                                    toElement.position.y + (toElement.height / 2) + boundsMargin))
        drawRulers(connectingSide: anchor)
        let grid = generateGridFromRulers(gridBounds: bounds)
        let gridPoints = generateGridPoints(grid)
        let graph = createGraph(points: gridPoints)
        let path = shortestPath(graph: graph, source: getSource(anchor), destination: getDestination())
        return path
    }
}
