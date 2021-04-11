import XCTest
import CoreGraphics
@testable import Dynavity

class OrthogonalConnectorTests: XCTestCase {
    var orthogonalConnector: OrthogonalConnector!
    var bounds: GridRectangle!
    var grid: Grid!
    var sourceUmlElement: UmlElementProtocol = ActivityUmlElement(position: CGPoint(x: 250, y: 250), shape: .diamond)
    var destinationUmlElement: UmlElementProtocol = ActivityUmlElement(position: CGPoint(x: 1_000, y: 1_000),
                                                                       shape: .diamond)

    override func setUpWithError() throws {
        try super.setUpWithError()
        orthogonalConnector = OrthogonalConnector(from: sourceUmlElement,
                                                  to: destinationUmlElement)
        bounds = orthogonalConnector.getGridBounds()
        orthogonalConnector.drawRulers(connectingSide: ConnectorConnectingSide.middleRight,
                                       destConnectingSide: .middleLeft)
        let verticalRulers = orthogonalConnector.verticalRulers
        let horizontalRulers = orthogonalConnector.horizontalRulers
        grid = Grid.generateGridFromRulers(gridBounds: bounds,
                                           horizontalRulers: horizontalRulers,
                                           verticalRulers: verticalRulers)
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

    func testGeneratePoint_differingAnchors_outputIncludeMargin() {
        let leftAnchorSource = orthogonalConnector
            .generatePoint(target: sourceUmlElement,
                           ConnectorConnectingSide.middleLeft)
        let rightAnchorSource = orthogonalConnector
            .generatePoint(target: sourceUmlElement,
                           ConnectorConnectingSide.middleRight)
        let topAnchorSource = orthogonalConnector
            .generatePoint(target: sourceUmlElement,
                           ConnectorConnectingSide.middleTop)
        let bottomAnchorSource = orthogonalConnector
            .generatePoint(target: sourceUmlElement,
                           ConnectorConnectingSide.middleBottom)
        XCTAssertEqual(leftAnchorSource, CGPoint(x: 175.0, y: 250.0))
        XCTAssertEqual(rightAnchorSource, CGPoint(x: 325.0, y: 250.0))
        XCTAssertEqual(topAnchorSource, CGPoint(x: 250.0, y: 175.0))
        XCTAssertEqual(bottomAnchorSource, CGPoint(x: 250.0, y: 325.0))
    }

    func testDrawRulers() {
        orthogonalConnector.drawRulers(connectingSide: ConnectorConnectingSide.middleRight,
                                       destConnectingSide: ConnectorConnectingSide.middleLeft)
        let verticalRulers = orthogonalConnector.verticalRulers
        let horizontalRulers = orthogonalConnector.horizontalRulers
        XCTAssertEqual(verticalRulers[0], 165.0)
        XCTAssertEqual(verticalRulers[1], 335.0)
        XCTAssertEqual(verticalRulers[2], 915.0)
        XCTAssertEqual(verticalRulers[3], 1_085.0)
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

    func testCreateGraph() {
        let points = grid.generateGridPoints(fromElement: sourceUmlElement,
                                             toElement: destinationUmlElement)
        let graph = orthogonalConnector.createGraph(points: points)
        let gridPoint = GridPoint(point: CGPoint(x: 335.0, y: 250.0))
        let graphNode = Node(gridPoint)
        XCTAssertEqual(graph.nodes.count, 111)
        XCTAssertEqual(graph.edges.count, 384)
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
        XCTAssertEqual(path[0], CGPoint(x: 325.0, y: 250.0))
        XCTAssertEqual(path[1], CGPoint(x: 335.0, y: 250.0))
        XCTAssertEqual(path[2], CGPoint(x: 335.0, y: 292.5))
        XCTAssertEqual(path[3], CGPoint(x: 335.0, y: 335.0))
        XCTAssertEqual(path[4], CGPoint(x: 335.0, y: 625.0))
        XCTAssertEqual(path[5], CGPoint(x: 335.0, y: 915.0))
        XCTAssertEqual(path[6], CGPoint(x: 335.0, y: 957.5))
        XCTAssertEqual(path[7], CGPoint(x: 335.0, y: 1_000.0))
        XCTAssertEqual(path[8], CGPoint(x: 625.0, y: 1_000.0))
    }

    func testGenerateRoute_middleRightToMiddleTop_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleRight, destAnchor: .middleTop)
        XCTAssertEqual(path[0], CGPoint(x: 325.0, y: 250.0))
        XCTAssertEqual(path[1], CGPoint(x: 335.0, y: 250.0))
        XCTAssertEqual(path[2], CGPoint(x: 335.0, y: 292.5))
        XCTAssertEqual(path[3], CGPoint(x: 335.0, y: 335.0))
        XCTAssertEqual(path[4], CGPoint(x: 335.0, y: 625.0))
        XCTAssertEqual(path[5], CGPoint(x: 335, y: 915.0))
        XCTAssertEqual(path[6], CGPoint(x: 625.0, y: 915.0))
        XCTAssertEqual(path[7], CGPoint(x: 915.0, y: 915.0))
        XCTAssertEqual(path[8], CGPoint(x: 957.5, y: 915.0))
    }

    func testGenerateRoute_middleLeftToMiddleRight_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleLeft, destAnchor: .middleRight)
        XCTAssertEqual(path[0], CGPoint(x: 175.0, y: 250.0))
        XCTAssertEqual(path[1], CGPoint(x: 165.0, y: 250.0))
        XCTAssertEqual(path[2], CGPoint(x: 165.0, y: 292.5))
        XCTAssertEqual(path[3], CGPoint(x: 165.0, y: 335.0))
        XCTAssertEqual(path[4], CGPoint(x: 165.0, y: 625.0))
        XCTAssertEqual(path[5], CGPoint(x: 165.0, y: 915.0))
        XCTAssertEqual(path[6], CGPoint(x: 250.0, y: 915.0))
        XCTAssertEqual(path[7], CGPoint(x: 335.0, y: 915.0))
        XCTAssertEqual(path[8], CGPoint(x: 625.0, y: 915.0))
        XCTAssertEqual(path[9], CGPoint(x: 915.0, y: 915.0))
        XCTAssertEqual(path[13], CGPoint(x: 1_085.0, y: 1_000))
        XCTAssertEqual(path[14], CGPoint(x: 1_075.0, y: 1_000))
    }

    func testGenerateRoute_middleBottomToMiddleBottom_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleBottom, destAnchor: .middleBottom)
        XCTAssertEqual(path[0], CGPoint(x: 250.0, y: 325.0))
        XCTAssertEqual(path[1], CGPoint(x: 250.0, y: 335.0))
        XCTAssertEqual(path[2], CGPoint(x: 250.0, y: 625.0))
        XCTAssertEqual(path[3], CGPoint(x: 250.0, y: 915.0))
        XCTAssertEqual(path[11], CGPoint(x: 1_000.0, y: 1_085.0))
        XCTAssertEqual(path[12], CGPoint(x: 1_000.0, y: 1_075.0))
    }

    func testGenerateRoute_middleTopToMiddleBottom_returnsOrthogonalPath() {
        let path = orthogonalConnector.generateRoute(.middleTop, destAnchor: .middleBottom)
        XCTAssertEqual(path[0], CGPoint(x: 250.0, y: 175.0))
        XCTAssertEqual(path[1], CGPoint(x: 250.0, y: 165.0))
        XCTAssertEqual(path[2], CGPoint(x: 292.5, y: 165.0))
        XCTAssertEqual(path[3], CGPoint(x: 335.0, y: 165.0))
        XCTAssertEqual(path[4], CGPoint(x: 335.0, y: 250.0))
        XCTAssertEqual(path[5], CGPoint(x: 335.0, y: 335.0))
        XCTAssertEqual(path[6], CGPoint(x: 335.0, y: 625.0))
        XCTAssertEqual(path[7], CGPoint(x: 335.0, y: 915.0))
        XCTAssertEqual(path[13], CGPoint(x: 1_000.0, y: 1_085.0))
        XCTAssertEqual(path[14], CGPoint(x: 1_000.0, y: 1_075.0))
    }

    func testGenerateRouteRotatedElement_middleTopToMiddleBottom_returnsOrthogonalPath() {
        let fourtyFiveDegClockwise = 0.785
        let fourtyFiveDegAntiClockwise = -0.785
        let rotatedSource = sourceUmlElement
        let rotatedDest = destinationUmlElement
        rotatedSource.rotate(to: fourtyFiveDegClockwise)
        rotatedDest.rotate(to: fourtyFiveDegAntiClockwise)
        let orthogonalConnector = OrthogonalConnector(from: rotatedSource,
                                                      to: rotatedDest)
        orthogonalConnector.drawRulers(connectingSide: ConnectorConnectingSide.middleRight,
                                       destConnectingSide: ConnectorConnectingSide.middleLeft)
        let path = orthogonalConnector.generateRoute(.middleTop, destAnchor: .middleBottom)
        XCTAssertEqual(path[0], CGPoint(x: 303.0, y: 197.0))
        XCTAssertEqual(path[1], CGPoint(x: 366.0, y: 197.0))
        XCTAssertEqual(path[2], CGPoint(x: 366.0, y: 281.5))
        XCTAssertEqual(path[3], CGPoint(x: 366.0, y: 366.0))
        XCTAssertEqual(path[4], CGPoint(x: 366.0, y: 625.0))
        XCTAssertEqual(path[5], CGPoint(x: 366.0, y: 884.0))
        XCTAssertEqual(path[6], CGPoint(x: 366.0, y: 968.5))
    }
}
