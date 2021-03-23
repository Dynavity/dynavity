import PencilKit

struct AnnotationPalette {
    static let annotationWidths: [CGFloat] = [3, 6, 9, 12]
    static let annotationColors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.gray]
    private let defaultTool = PKInkingTool(.pen, color: .blue, width: 10)

    var selectedTool: PKTool

    init() {
        selectedTool = defaultTool
    }

    mutating func switchTool(_ newTool: PKTool) {
        selectedTool = newTool
    }

    mutating func switchAnnotationWidth(_ newWidth: CGFloat) {
        guard let inkingTool = selectedTool as? PKInkingTool else {
            return
        }

        // Only pen and and marker (highlighter) inking tools used
        if inkingTool.inkType == .pen {
            selectedTool = PKInkingTool(.pen, color: inkingTool.color, width: newWidth)
        } else {
            selectedTool = PKInkingTool(.marker, color: inkingTool.color, width: newWidth)
        }
    }

    mutating func switchAnnotationColor(_ newColor: UIColor) {
        guard let inkingTool = selectedTool as? PKInkingTool else {
            return
        }

        // Only pen and and marker (highlighter) inking tools used
        if inkingTool.inkType == .pen {
            selectedTool = PKInkingTool(.pen, color: newColor, width: inkingTool.width)
        } else {
            selectedTool = PKInkingTool(.marker, color: newColor, width: inkingTool.width)
        }
    }
}
