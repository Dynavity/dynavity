import XCTest
import CoreGraphics
@testable import Dynavity

class OrthogonalConnectorTests: XCTestCase {
    var orthogonalConnector: OrthogonalConnector!
    var bounds: GridRectangle!
    var grid: Grid!
    var sourceUmlElement: UmlElementProtocol = RectangleUmlElement(position: CGPoint(x: 250, y: 250))
    var destinationUmlElement: UmlElementProtocol = RectangleUmlElement(position: CGPoint(x: 1_000, y: 1_000))

    override func setUpWithError() throws {
        try super.setUpWithError()
        orthogonalConnector = OrthogonalConnector(from: sourceUmlElement,
                                                  to: destinationUmlElement)
        bounds = orthogonalConnector.getGridBounds()
        orthogonalConnector.drawRulers(connectingSide: ConnectorConnectingSide.middleRight)
        grid = orthogonalConnector.generateGridFromRulers(gridBounds: bounds)
    }

    override func tearDownWithError() throws {
        orthogonalConnector = nil
        bounds = nil
        grid = nil
        try super.tearDownWithError()
    }

    func testInit() {
        let connector = OrthogonalConnector(from: sourceUmlElement,
                                            to: destinationUmlElement)
        XCTAssertTrue(connector.shapeMargin == 10.0)
        XCTAssertTrue(connector.boundsMargin == 20.0)
        XCTAssertTrue(connector.verticalRulers.isEmpty)
        XCTAssertTrue(connector.horizontalRulers.isEmpty)
    }

    func testExtrudePoint_differingAnchors_outputIncludeMargin() {
        let leftAnchorSource = orthogonalConnector
            .extrudePoint(target: sourceUmlElement,
                          ConnectorConnectingSide.middleLeft)
        let rightAnchorSource = orthogonalConnector
            .extrudePoint(target: sourceUmlElement,
                          ConnectorConnectingSide.middleRight)
        let topAnchorSource = orthogonalConnector
            .extrudePoint(target: sourceUmlElement,
                          ConnectorConnectingSide.middleTop)
        let bottomAnchorSource = orthogonalConnector
            .extrudePoint(target: sourceUmlElement,
                          ConnectorConnectingSide.middleBottom)
        XCTAssertEqual(leftAnchorSource, CGPoint(x: 165.0, y: 250.0))
        XCTAssertEqual(rightAnchorSource, CGPoint(x: 335.0, y: 250.0))
        XCTAssertEqual(topAnchorSource, CGPoint(x: 250.0, y: 165.0))
        XCTAssertEqual(bottomAnchorSource, CGPoint(x: 250.0, y: 335.0))
    }

    func testDrawRulers() {
        orthogonalConnector.drawRulers(connectingSide: ConnectorConnectingSide.middleRight)
        let verticalRulers = orthogonalConnector.verticalRulers
        let horizontalRulers = orthogonalConnector.horizontalRulers
        XCTAssertEqual(verticalRulers[0], 165.0)
        XCTAssertEqual(verticalRulers[1], 335.0)
        XCTAssertEqual(verticalRulers[2], 915.0)
        XCTAssertEqual(verticalRulers[3], 1_000.0)
        XCTAssertEqual(verticalRulers[4], 1_085.0)
        XCTAssertEqual(horizontalRulers[0], 165.0)
        XCTAssertEqual(horizontalRulers[1], 250.0)
        XCTAssertEqual(horizontalRulers[2], 335.0)
        XCTAssertEqual(horizontalRulers[3], 915.0)
        XCTAssertEqual(horizontalRulers[4], 1_000.0)
        XCTAssertEqual(horizontalRulers[5], 1_085.0)
    }

    func testGetGridBounds() {
        XCTAssertEqual(bounds.leftEdge, 155.0)
        XCTAssertEqual(bounds.rightEdge, 1_095.0)
        XCTAssertEqual(bounds.topEdge, 155.0)
        XCTAssertEqual(bounds.bottomEdge, 1_095.0)
    }

    func testGenerateGridFromRulers_topCorners() {
        XCTAssertEqual(grid.rectangles[0]![0]!.leftEdge, 155.0)
        XCTAssertEqual(grid.rectangles[0]![0]!.rightEdge, 165.0)
        XCTAssertEqual(grid.rectangles[0]![0]!.topEdge, 155.0)
        XCTAssertEqual(grid.rectangles[0]![0]!.bottomEdge, 165.0)

        XCTAssertEqual(grid.rectangles[0]![5]!.leftEdge, 1_085.0)
        XCTAssertEqual(grid.rectangles[0]![5]!.rightEdge, 1_095.0)
        XCTAssertEqual(grid.rectangles[0]![5]!.bottomEdge, 165.0)
        XCTAssertEqual(grid.rectangles[0]![5]!.topEdge, 155.0)
    }

    func testGenerateGridFromRulers_bottomCorners() {
        XCTAssertEqual(grid.rectangles[6]![0]!.leftEdge, 155.0)
        XCTAssertEqual(grid.rectangles[6]![0]!.rightEdge, 165.0)
        XCTAssertEqual(grid.rectangles[6]![0]!.topEdge, 1_085.0)
        XCTAssertEqual(grid.rectangles[6]![0]!.bottomEdge, 1_095.0)

        XCTAssertEqual(grid.rectangles[6]![5]!.leftEdge, 1_085.0)
        XCTAssertEqual(grid.rectangles[6]![5]!.rightEdge, 1_095.0)
        XCTAssertEqual(grid.rectangles[6]![5]!.topEdge, 1_085.0)
        XCTAssertEqual(grid.rectangles[6]![5]!.bottomEdge, 1_095.0)
    }

    func testGenerateGridFromRulers_middleRectangles() {
        XCTAssertEqual(grid.rectangles[3]![2]!.leftEdge, 335.0)
        XCTAssertEqual(grid.rectangles[3]![2]!.rightEdge, 915.0)
        XCTAssertEqual(grid.rectangles[3]![2]!.topEdge, 335.0)
        XCTAssertEqual(grid.rectangles[3]![2]!.bottomEdge, 915.0)

        XCTAssertEqual(grid.rectangles[2]![3]!.leftEdge, 915.0)
        XCTAssertEqual(grid.rectangles[2]![3]!.rightEdge, 1_000.0)
        XCTAssertEqual(grid.rectangles[2]![3]!.topEdge, 250.0)
        XCTAssertEqual(grid.rectangles[2]![3]!.bottomEdge, 335.0)
    }

    func testGenerateGridPoints() {
        let points = orthogonalConnector.generateGridPoints(grid)
        XCTAssertEqual(points.count, 134)
    }

    func testCreateGraph() {
        let points = orthogonalConnector.generateGridPoints(grid)
        let graph = orthogonalConnector.createGraph(points: points)
        let gridPoint = GridPoint(point: CGPoint(x: 335.0, y: 250.0))
        let graphNode = Node(gridPoint)
        XCTAssertEqual(graph.nodes.count, 134)
        XCTAssertEqual(graph.edges.count, 476)
        XCTAssertEqual(graph.getNode(graphNode)!.label, gridPoint)
    }

    func testGetDirectionOfNodes_verticalDirection() {
        let sourceVert = GridPoint(point: CGPoint(x: 335.0, y: 250.0))
        let destVert = GridPoint(point: CGPoint(x: 335.0, y: 350.0))
        XCTAssertEqual(orthogonalConnector
                        .getDirectionOfNodes(source: sourceVert, destination: destVert),
                       OrthogonalConnector.PathDirection.vertical)
    }

    func testGetDirectionOfNodes_horizontalDirection() {
        let sourceHorizontal = GridPoint(point: CGPoint(x: 335.0, y: 250.0))
        let destHorizontal = GridPoint(point: CGPoint(x: 435.0, y: 250.0))
        XCTAssertEqual(orthogonalConnector
                        .getDirectionOfNodes(source: sourceHorizontal, destination: destHorizontal),
                       OrthogonalConnector.PathDirection.horizontal)
    }

    func testGetDirectionOfNodes_notHorizontalOrVertical() {
        let sourceNeither = GridPoint(point: CGPoint(x: 335.0, y: 250.0))
        let destNeither = GridPoint(point: CGPoint(x: 435.0, y: 350.0))
        XCTAssertNil(orthogonalConnector
                        .getDirectionOfNodes(source: sourceNeither, destination: destNeither))
    }

    func testGetCurrPathDirection_verticalDirection() {
        let prevPoint = Node(GridPoint(point: CGPoint(x: 250.0, y: 350.0)))
        let currPoint = Node(GridPoint(point: CGPoint(x: 250.0, y: 450.0)))
        currPoint.label.pathNodesFromSource = [prevPoint.label]
        XCTAssertEqual(orthogonalConnector.getCurrPathDirection(currPoint),
                       OrthogonalConnector.PathDirection.vertical)
    }

    func testGetCurrPathDirection_horizontalDirection() {
        let prevPoint = Node(GridPoint(point: CGPoint(x: 150.0, y: 450.0)))
        let currPoint = Node(GridPoint(point: CGPoint(x: 250.0, y: 450.0)))
        currPoint.label.pathNodesFromSource = [prevPoint.label]
        XCTAssertEqual(orthogonalConnector.getCurrPathDirection(currPoint),
                       OrthogonalConnector.PathDirection.horizontal)
    }

    func testGetCurrPathDirection_notHorizontalOrVertical() {
        let prevPoint = Node(GridPoint(point: CGPoint(x: 150.0, y: 350.0)))
        let currPoint = Node(GridPoint(point: CGPoint(x: 250.0, y: 450.0)))
        currPoint.label.pathNodesFromSource = [prevPoint.label]
        XCTAssertNil(orthogonalConnector.getCurrPathDirection(currPoint))
    }

    func testGenerateRoute_middleRightToMiddleLeft_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleRight, destAnchor: .middleLeft)
        XCTAssertEqual(path[0], CGPoint(x: 335.0, y: 250.0))
        XCTAssertEqual(path[1], CGPoint(x: 335.0, y: 292.5))
        XCTAssertEqual(path[2], CGPoint(x: 335.0, y: 335.0))
        XCTAssertEqual(path[3], CGPoint(x: 335.0, y: 625.0))
        XCTAssertEqual(path[4], CGPoint(x: 335.0, y: 915.0))
        XCTAssertEqual(path[5], CGPoint(x: 335.0, y: 957.5))
        XCTAssertEqual(path[6], CGPoint(x: 335.0, y: 1_000.0))
        XCTAssertEqual(path[7], CGPoint(x: 625.0, y: 1_000.0))
        XCTAssertEqual(path[8], CGPoint(x: 915.0, y: 1_000.0))
    }

    func testGenerateRoute_middleRightToMiddleTop_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleRight, destAnchor: .middleTop)
        XCTAssertEqual(path[0], CGPoint(x: 335.0, y: 250.0))
        XCTAssertEqual(path[1], CGPoint(x: 335.0, y: 292.5))
        XCTAssertEqual(path[2], CGPoint(x: 335.0, y: 335.0))
        XCTAssertEqual(path[3], CGPoint(x: 335.0, y: 625.0))
        XCTAssertEqual(path[4], CGPoint(x: 335.0, y: 915.0))
        XCTAssertEqual(path[5], CGPoint(x: 625, y: 915.0))
        XCTAssertEqual(path[6], CGPoint(x: 915.0, y: 915.0))
        XCTAssertEqual(path[7], CGPoint(x: 957.5, y: 915.0))
        XCTAssertEqual(path[8], CGPoint(x: 1_000.0, y: 915.0))
    }

    func testGenerateRoute_middleLeftToMiddleRight_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleLeft, destAnchor: .middleRight)
        XCTAssertEqual(path[0], CGPoint(x: 165.0, y: 250.0))
        XCTAssertEqual(path[1], CGPoint(x: 165.0, y: 292.5))
        XCTAssertEqual(path[2], CGPoint(x: 165.0, y: 335.0))
        XCTAssertEqual(path[3], CGPoint(x: 165.0, y: 625.0))
        XCTAssertEqual(path[7], CGPoint(x: 625.0, y: 915.0))
        XCTAssertEqual(path[8], CGPoint(x: 915.0, y: 915.0))
        XCTAssertEqual(path[9], CGPoint(x: 957.5, y: 915.0))
        XCTAssertEqual(path[10], CGPoint(x: 1_000.0, y: 915.0))
        XCTAssertEqual(path[11], CGPoint(x: 1_042.5, y: 915.0))
        XCTAssertEqual(path[12], CGPoint(x: 1_085.0, y: 915.0))
        XCTAssertEqual(path[13], CGPoint(x: 1_085.0, y: 957.5))
        XCTAssertEqual(path[14], CGPoint(x: 1_085.0, y: 1_000.0))
    }

    func testGenerateRoute_middleBottomToMiddleBottom_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleBottom, destAnchor: .middleBottom)
        XCTAssertEqual(path[0], CGPoint(x: 250.0, y: 335.0))
        XCTAssertEqual(path[1], CGPoint(x: 250.0, y: 625.0))
        XCTAssertEqual(path[2], CGPoint(x: 250.0, y: 915.0))
        XCTAssertEqual(path[3], CGPoint(x: 250.0, y: 957.5))
        XCTAssertEqual(path[6], CGPoint(x: 250.0, y: 1_085.0))
        XCTAssertEqual(path[7], CGPoint(x: 292.5, y: 1_085.0))
        XCTAssertEqual(path[8], CGPoint(x: 335.0, y: 1_085.0))
        XCTAssertEqual(path[9], CGPoint(x: 625.0, y: 1_085.0))
        XCTAssertEqual(path[10], CGPoint(x: 915.0, y: 1_085.0))
        XCTAssertEqual(path[11], CGPoint(x: 957.5, y: 1_085.0))
        XCTAssertEqual(path[12], CGPoint(x: 1_000.0, y: 1_085.0))
    }

    func testGenerateRoute_middleTopToMiddleBottom_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleTop, destAnchor: .middleBottom)
        XCTAssertEqual(path[0], CGPoint(x: 250.0, y: 165.0))
        XCTAssertEqual(path[1], CGPoint(x: 250.0, y: 250.0))
        XCTAssertEqual(path[2], CGPoint(x: 250.0, y: 335.0))
        XCTAssertEqual(path[3], CGPoint(x: 250.0, y: 625.0))
        XCTAssertEqual(path[4], CGPoint(x: 250.0, y: 915.0))
        XCTAssertEqual(path[5], CGPoint(x: 250.0, y: 957.5))
        XCTAssertEqual(path[9], CGPoint(x: 292.5, y: 1_085.0))
        XCTAssertEqual(path[10], CGPoint(x: 335.0, y: 1_085.0))
        XCTAssertEqual(path[11], CGPoint(x: 625.0, y: 1_085.0))
        XCTAssertEqual(path[12], CGPoint(x: 915.0, y: 1_085.0))
        XCTAssertEqual(path[13], CGPoint(x: 957.5, y: 1_085.0))
        XCTAssertEqual(path[14], CGPoint(x: 1_000.0, y: 1_085.0))
    }
}
