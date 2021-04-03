import SwiftUI

/**
 Arrowheads here are pertinent to UML diagramming arrow heads . For example arrows used in a class diagram
 or an activity diagram.
 */
extension Path {
    // Start and end point should already account for view offset
    mutating func addArrow(start: CGPoint, end: CGPoint) {
        let arrowLength: CGFloat = 15.0
        let arrowAngle: CGFloat = CGFloat.pi / 4
        let startEndAngle = atan((end.y - start.y) / (end.x - start.x))
            + ((end.x - start.x) < 0 ? CGFloat.pi : 0)

        let firstArrowLinePoint = CGPoint(x: end.x + arrowLength * cos(CGFloat.pi - startEndAngle + arrowAngle),
                                          y: end.y - arrowLength * sin(CGFloat.pi - startEndAngle + arrowAngle))
        let secondArrowLinePoint = CGPoint(x: end.x + arrowLength * cos(CGFloat.pi - startEndAngle - arrowAngle),
                                           y: end.y - arrowLength * sin(CGFloat.pi - startEndAngle - arrowAngle))

        move(to: end)
        addLine(to: firstArrowLinePoint)
        move(to: end)
        addLine(to: secondArrowLinePoint)
    }
}
