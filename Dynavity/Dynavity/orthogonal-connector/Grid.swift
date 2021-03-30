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
}
