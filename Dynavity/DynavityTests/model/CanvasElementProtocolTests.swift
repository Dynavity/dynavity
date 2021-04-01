import XCTest
import CoreGraphics
@testable import Dynavity

class CanvasElementProtocolTests: XCTestCase {
    let element: UmlElementProtocol = RectangleUmlElement(position: CGPoint(x: 1_000, y: 1_000))

    func testContainsPoint() {
        let internalPoint = CGPoint(x: 1_020, y: 1_000)
        let externalPoint = CGPoint(x: 1_085, y: 1_000)
        XCTAssertTrue(element.containsPoint(internalPoint))
        XCTAssertFalse(element.containsPoint(externalPoint))
    }
}
