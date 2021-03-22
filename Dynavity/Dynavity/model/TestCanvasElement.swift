import Foundation
import CoreGraphics

/**
 Test element to use when creating a canvas. This struct can be removed when real canvas elements are created.
 */
struct TestElement: CanvasElementProtocol, Identifiable {
    typealias elementID = UUID

    var id = elementID()
    var position: CGPoint = .zero
    var width: CGFloat = 100.0
    var height: CGFloat = 100.0
    var rotation = Double.pi / 4.0

    static func == (lhs: TestElement, rhs: TestElement) -> Bool {
        lhs.id == rhs.id
    }
}
