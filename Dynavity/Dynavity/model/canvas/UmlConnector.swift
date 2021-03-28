import Foundation
import CoreGraphics

/**
 Encapsulates a connector between two UML shapes.
 */
struct UmlConnector {
    var id = UUID()
    var points: [CGPoint] = []

    mutating func addPoint(_ point: CGPoint) {
        points.append(point)
    }
}
