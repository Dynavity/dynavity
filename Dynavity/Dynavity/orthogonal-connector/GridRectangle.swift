import CoreGraphics

/**
 This represents rectangles in a `Grid`.
 
 This is used as part of the algorithm to find the orthogonal diagram connector routing between UmlElements.
 */
struct GridRectangle {
    let width: CGFloat
    let height: CGFloat
    // X-coordinate left edge
    let leftEdge: CGFloat
    // Y-coordinate top edge
    let topEdge: CGFloat

    var center: CGPoint {
        CGPoint(x: leftEdge + (width / 2),
                y: topEdge + (height / 2))
    }
    var rightEdge: CGFloat {
        leftEdge + width
    }
    var bottomEdge: CGFloat {
        topEdge + height
    }

    var topLeftPoint: CGPoint {
        CGPoint(x: leftEdge, y: topEdge)
    }
    var topRightPoint: CGPoint {
        CGPoint(x: rightEdge, y: topEdge)
    }
    var bottomLeftPoint: CGPoint {
        CGPoint(x: leftEdge, y: bottomEdge)
    }
    var bottomRightPoint: CGPoint {
        CGPoint(x: rightEdge, y: bottomEdge)
    }
    var topPoint: CGPoint {
        CGPoint(x: center.x, y: topEdge)
    }
    var bottomPoint: CGPoint {
        CGPoint(x: center.x, y: bottomEdge)
    }
    var leftPoint: CGPoint {
        CGPoint(x: leftEdge, y: center.y)
    }
    var rightPoint: CGPoint {
        CGPoint(x: rightEdge, y: center.y)
    }

    private init(left: CGFloat, top: CGFloat, width: CGFloat, height: CGFloat) {
        leftEdge = left
        topEdge = top
        self.width = width
        self.height = height
    }

    static func fromLTRB(left: CGFloat, top: CGFloat, right: CGFloat, bottom: CGFloat) -> GridRectangle {
        GridRectangle(left: left, top: top, width: right - left, height: bottom - top)
    }
}
