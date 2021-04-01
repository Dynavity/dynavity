import XCTest
import CoreGraphics
@testable import Dynavity

class GridRectangleTests: XCTestCase {
    let gridRectangle = GridRectangle.fromLTRB(left: 150, top: 250,
                                               right: 250, bottom: 350)
    func testCreate_validRect() {
        let testGridRect = GridRectangle.fromLTRB(left: 350, top: 450,
                                                  right: 450, bottom: 550)
        XCTAssertEqual(testGridRect.width, 100)
        XCTAssertEqual(testGridRect.height, 100)
    }

    func testVariables() {
        XCTAssertEqual(gridRectangle.width, 100)
        XCTAssertEqual(gridRectangle.height, 100)
        XCTAssertEqual(gridRectangle.leftEdge, 150)
        XCTAssertEqual(gridRectangle.topEdge, 250)
        XCTAssertEqual(gridRectangle.center, CGPoint(x: 200, y: 300))
        XCTAssertEqual(gridRectangle.rightEdge, 250)
        XCTAssertEqual(gridRectangle.bottomEdge, 350)
        XCTAssertEqual(gridRectangle.topLeftPoint, CGPoint(x: 150, y: 250))
        XCTAssertEqual(gridRectangle.topRightPoint, CGPoint(x: 250, y: 250))
        XCTAssertEqual(gridRectangle.bottomLeftPoint, CGPoint(x: 150, y: 350))
        XCTAssertEqual(gridRectangle.bottomRightPoint, CGPoint(x: 250, y: 350))
        XCTAssertEqual(gridRectangle.leftPoint, CGPoint(x: 150, y: 300))
        XCTAssertEqual(gridRectangle.rightPoint, CGPoint(x: 250, y: 300))
    }
}
