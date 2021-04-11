import XCTest
import CoreGraphics
@testable import Dynavity

class CanvasElementProtocolTests: XCTestCase {
    var element: UmlElementProtocol = ActivityUmlElement(position: CGPoint(x: 1_000, y: 1_000), shape: .diamond)

    func testContainsPoint() {
        let internalPoint = CGPoint(x: 1_020, y: 1_000)
        let externalPoint = CGPoint(x: 1_085, y: 1_000)
        XCTAssertTrue(element.containsPoint(internalPoint))
        XCTAssertFalse(element.containsPoint(externalPoint))
    }

    func testGetRotatedElementCorners() {
        let rotatedElement = element
        let fourtyFiveClockwise = 0.785
        rotatedElement.rotate(to: fourtyFiveClockwise)
        XCTAssertEqual(rotatedElement.topLeftCorner.x.rounded(), 1_000)
        XCTAssertEqual(rotatedElement.topLeftCorner.y.rounded(), 894)

        XCTAssertEqual(rotatedElement.topRightCorner.x.rounded(), 1_106)
        XCTAssertEqual(rotatedElement.topRightCorner.y.rounded(), 1_000)

        XCTAssertEqual(rotatedElement.bottomLeftCorner.x.rounded(), 894)
        XCTAssertEqual(rotatedElement.bottomLeftCorner.y.rounded(), 1_000)

        XCTAssertEqual(rotatedElement.bottomRightCorner.x.rounded(), 1_000)
        XCTAssertEqual(rotatedElement.bottomRightCorner.y.rounded(), 1_106)
    }

    func testGetMinMaxPoints() {
        let rotatedElement = element
        let fourtyFiveClockwise = 0.785
        rotatedElement.rotate(to: fourtyFiveClockwise)

        XCTAssertEqual(rotatedElement.topMostPoint.y.rounded(), 894)
        XCTAssertEqual(rotatedElement.bottomMostPoint.y.rounded(), 1_106)
        XCTAssertEqual(rotatedElement.leftMostPoint.x.rounded(), 894)
        XCTAssertEqual(rotatedElement.rightMostPoint.x.rounded(), 1_106)

        rotatedElement.rotate(to: fourtyFiveClockwise * 2)

        XCTAssertEqual(rotatedElement.topMostPoint.y.rounded(), 925)
        XCTAssertEqual(rotatedElement.bottomMostPoint.y.rounded(), 1_075)
        XCTAssertEqual(rotatedElement.leftMostPoint.x.rounded(), 925)
        XCTAssertEqual(rotatedElement.rightMostPoint.x.rounded(), 1_075)

        rotatedElement.rotate(to: fourtyFiveClockwise * 3)

        XCTAssertEqual(rotatedElement.topMostPoint.y.rounded(), 894)
        XCTAssertEqual(rotatedElement.bottomMostPoint.y.rounded(), 1_106)
        XCTAssertEqual(rotatedElement.leftMostPoint.x.rounded(), 894)
        XCTAssertEqual(rotatedElement.rightMostPoint.x.rounded(), 1_106)
    }
}
