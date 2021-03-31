import CoreGraphics

/**
 Grid is used in `OrthogonalConnector` to represent grids of rectangles drawn between the
 separate UmlElements
 
 This is used as part of the algorithm to find the orthogonal diagram connector routing between UmlElements.
 */
class Grid {
    var rows: Int = 0
    var cols: Int = 0

    var rectangles: [Int: [Int: GridRectangle]] = Dictionary()

    init() {}

    // Set a rectangle to a specefic row and column in the grid
    func set(row: Int, col: Int, rectangle: GridRectangle) {
        rows = max(self.rows, row + 1)
        cols = max(self.cols, col + 1)

        if rectangles[row] == nil {
            rectangles.updateValue([Int: GridRectangle](), forKey: row)
        }
        rectangles[row]?.updateValue(rectangle, forKey: col)
    }

    func getGridRectangles() -> [GridRectangle] {
        var gridRectangles: [GridRectangle] = []

        for (_, dict) in rectangles {
            for (_, rectangle) in dict {
                gridRectangles.append(rectangle)
            }
        }
        return gridRectangles
    }

    static func generateGridFromRulers(gridBounds: GridRectangle,
                                       horizontalRulers: [CGFloat],
                                       verticalRulers: [CGFloat]) -> Grid {
        let grid = Grid()
        var lastX = gridBounds.leftEdge
        var lastY = gridBounds.topEdge
        var column = 0
        var row = 0

        for y in horizontalRulers {
            for x in verticalRulers {
                grid.set(row: row,
                         col: column,
                         rectangle: GridRectangle.fromLTRB(left: lastX, top: lastY, right: x, bottom: y))
                column += 1
                lastX = x
            }

            grid.set(row: row,
                     col: column,
                     rectangle: GridRectangle.fromLTRB(left: lastX, top: lastY, right: gridBounds.rightEdge, bottom: y))
            lastX = gridBounds.leftEdge
            lastY = y
            column = 0
            row += 1
        }

        lastX = gridBounds.leftEdge

        // Last row of cells
        for x in verticalRulers {
            grid.set(row: row,
                     col: column,
                     rectangle: GridRectangle.fromLTRB(left: lastX,
                                                       top: lastY,
                                                       right: x,
                                                       bottom: gridBounds.bottomEdge))
            column += 1
            lastX = x
        }
        // Last cell of last row
        grid.set(row: row,
                 col: column,
                 rectangle: GridRectangle.fromLTRB(left: lastX,
                                                   top: lastY,
                                                   right: gridBounds.rightEdge,
                                                   bottom: gridBounds.bottomEdge))

        return grid
    }

    // The points generated doesn't take into account obstacles(other UmlElementProtocols) in the grid
    func generateGridPoints(toElement: UmlElementProtocol) -> [CGPoint] {
        var gridPoints: [CGPoint] = []

        for (row, dict) in rectangles {
            let isFirstRow = row == 0
            let isLastRow = row == rows - 1

            for (col, rectangle) in dict {
                let isFirstCol = col == 0
                let isLastCol = col == cols - 1
                let isTopLeft = isFirstRow && isFirstCol
                let isTopRight = isFirstRow && isLastCol
                let isBottomLeft = isLastRow && isFirstCol
                let isBottomRight = isLastRow && isLastCol

                // Add various reference points depending on position of rectangle on grid
                if isTopLeft || isTopRight || isBottomLeft || isBottomRight {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint, rectangle.topRightPoint,
                                                   rectangle.bottomLeftPoint, rectangle.bottomRightPoint])
                } else if isFirstRow {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint, rectangle.topPoint, rectangle.topRightPoint])
                } else if isLastRow {
                    gridPoints.append(contentsOf: [rectangle.bottomRightPoint,
                                                   rectangle.bottomPoint,
                                                   rectangle.bottomLeftPoint])
                } else if isFirstCol {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint,
                                                   rectangle.leftPoint,
                                                   rectangle.bottomLeftPoint])
                } else if isLastCol {
                    gridPoints.append(contentsOf: [rectangle.topRightPoint,
                                                   rectangle.rightPoint,
                                                   rectangle.bottomRightPoint])
                } else {
                    gridPoints.append(contentsOf: [rectangle.topLeftPoint, rectangle.topPoint,
                                                   rectangle.topRightPoint, rectangle.rightPoint,
                                                   rectangle.bottomRightPoint, rectangle.bottomPoint,
                                                   rectangle.bottomLeftPoint, rectangle.leftPoint,
                                                   rectangle.center])
                }
            }
        }
        // Order of gridPoints is not preserved with .uniqued()
        let points = gridPoints.uniqued().filter { !toElement.containsPoint($0) }
        return points
    }
}
