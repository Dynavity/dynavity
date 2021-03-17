import Foundation
import CoreGraphics

/**
 Test element to use when creating a canvas. This struct can be removed when real canvas elements are created.
 */
struct TestCanvasElement: CanvasElementProtocol, Identifiable {
    typealias elementID = UUID

    var id = elementID()
    var position: CGPoint = .zero
    var text: String = ""

    static func == (lhs: TestCanvasElement, rhs: TestCanvasElement) -> Bool {
        lhs.id == rhs.id
    }
}
