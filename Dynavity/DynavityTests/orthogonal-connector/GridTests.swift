import XCTest
import CoreGraphics
@testable import Dynavity

class GridTests: XCTestCase {
    var orthogonalConnectorGrid: Grid!
    var testGrid: Grid!
    let rect1 = GridRectangle.fromLTRB(left: 150, top: 250,
                                       right: 250, bottom: 350)
    let rect2 = GridRectangle.fromLTRB(left: 350, top: 450,
                                       right: 450, bottom: 550)
    let rect3 = GridRectangle.fromLTRB(left: 750, top: 950,
                                       right: 850, bottom: 1_050)
    let rect4 = GridRectangle.fromLTRB(left: 1_150, top: 1_250,
                                       right: 1_250, bottom: 1_350)
    let verticalRulers: [CGFloat] = [165.0, 335.0, 915.0, 1_000.0, 1_085.0]
    let horizontalRulers: [CGFloat] = [165.0, 250.0, 335.0, 915.0, 1_000.0, 1_085.0]
    let orthogonalConnectorGridBounds = GridRectangle.fromLTRB(left: 155.0,
                                                               top: 155.0,
                                                               right: 1_095.0,
                                                               bottom: 1_095.0)

    override func setUpWithError() throws {
        try super.setUpWithError()
        testGrid = Grid()
        testGrid.set(row: 0, col: 0, rectangle: rect1)
        testGrid.set(row: 0, col: 2, rectangle: rect2)
        testGrid.set(row: 3, col: 1, rectangle: rect3)
        testGrid.set(row: 2, col: 2, rectangle: rect4)
        orthogonalConnectorGrid = Grid
            .generateGridFromRulers(gridBounds: orthogonalConnectorGridBounds,
                                    horizontalRulers: horizontalRulers,
                                    verticalRulers: verticalRulers)
    }

    override func tearDownWithError() throws {
        testGrid = nil
        orthogonalConnectorGrid = nil
        try super.tearDownWithError()
    }

    func testInit() {
        let grid = Grid()
        XCTAssertEqual(grid.rows, 0)
        XCTAssertEqual(grid.cols, 0)
        XCTAssertTrue(grid.rectangles.isEmpty)
    }

    func testSet_elementsSet() {
        XCTAssertEqual(testGrid.rectangles[0]![0]!, rect1)
        XCTAssertEqual(testGrid.rectangles[0]![2]!, rect2)
        XCTAssertEqual(testGrid.rectangles[3]![1]!, rect3)
        XCTAssertEqual(testGrid.rectangles[2]![2]!, rect4)
    }

    func testSet_rowsUpdated() {
        XCTAssertTrue(testGrid.rows == 4)
    }

    func testSet_colsUpdated() {
        XCTAssertTrue(testGrid.cols == 3)
    }

    func testGetGridRectangles() {
        let gridRects = testGrid.getGridRectangles()
        XCTAssertTrue(gridRects.count == 4)
    }

    func testGenerateGridFromRulers_topCorners() {
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![0]!.leftEdge, 155.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![0]!.rightEdge, 165.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![0]!.topEdge, 155.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![0]!.bottomEdge, 165.0)

        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![5]!.leftEdge, 1_085.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![5]!.rightEdge, 1_095.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![5]!.bottomEdge, 165.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[0]![5]!.topEdge, 155.0)
    }

    func testGenerateGridFromRulers_bottomCorners() {
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![0]!.leftEdge, 155.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![0]!.rightEdge, 165.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![0]!.topEdge, 1_085.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![0]!.bottomEdge, 1_095.0)

        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![5]!.leftEdge, 1_085.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![5]!.rightEdge, 1_095.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![5]!.topEdge, 1_085.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[6]![5]!.bottomEdge, 1_095.0)

    }

    func testGenerateGridFromRulers_middleRectangles() {
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[3]![2]!.leftEdge, 335.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[3]![2]!.rightEdge, 915.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[3]![2]!.topEdge, 335.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[3]![2]!.bottomEdge, 915.0)

        XCTAssertEqual(orthogonalConnectorGrid.rectangles[2]![3]!.leftEdge, 915.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[2]![3]!.rightEdge, 1_000.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[2]![3]!.topEdge, 250.0)
        XCTAssertEqual(orthogonalConnectorGrid.rectangles[2]![3]!.bottomEdge, 335.0)
    }

    func testGenerateGridPoints() {
        let destinationUmlElement: UmlElementProtocol = RectangleUmlElement(position: CGPoint(x: 1_000, y: 1_000))
        let points = orthogonalConnectorGrid.generateGridPoints(toElement: destinationUmlElement)
        XCTAssertEqual(points.count, 134)
    }
}
