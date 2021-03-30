import XCTest
import CoreGraphics
@testable import Dynavity

class GridTests: XCTestCase {
    var testGrid = Grid()
    let rect1 = GridRectangle.fromLTRB(left: 150, top: 250,
                                       right: 250, bottom: 350)
    let rect2 = GridRectangle.fromLTRB(left: 350, top: 450,
                                       right: 450, bottom: 550)
    let rect3 = GridRectangle.fromLTRB(left: 750, top: 950,
                                       right: 850, bottom: 1_050)
    let rect4 = GridRectangle.fromLTRB(left: 1_150, top: 1_250,
                                       right: 1_250, bottom: 1_350)
    override func setUpWithError() throws {
        try super.setUpWithError()
        testGrid.set(row: 0, col: 0, rectangle: rect1)
        testGrid.set(row: 0, col: 2, rectangle: rect2)
        testGrid.set(row: 3, col: 1, rectangle: rect3)
        testGrid.set(row: 2, col: 2, rectangle: rect4)
    }

    override func tearDownWithError() throws {
        testGrid = Grid()
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
}
