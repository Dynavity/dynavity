import PencilKit

struct AnnotationPalette {
    static let annotationWidths: [CGFloat] = [3, 6, 9, 12]
    static let annotationColors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.yellow]
    static let defaultPenTool = PKInkingTool(.pen, color: .blue, width: annotationWidths[2])
    static let defaultMarkerTool = PKInkingTool(.marker, color: .yellow, width: annotationWidths[2])

    var selectedTool: PKTool

    init() {
        selectedTool = AnnotationPalette.defaultPenTool
    }

    mutating func switchTool(_ newTool: PKTool) {
        selectedTool = newTool
    }

    mutating func switchAnnotationWidth(_ newWidth: CGFloat) {
        guard let inkingTool = selectedTool as? PKInkingTool else {
            return
        }

        // Only pen and and marker (highlighter) inking tools used
        switch inkingTool.inkType {
        case .pen:
            selectedTool = PKInkingTool(.pen, color: inkingTool.color, width: newWidth)
        case .marker:
            selectedTool = PKInkingTool(.marker, color: inkingTool.color, width: newWidth)
        case .pencil:
            fatalError("PKInkingTool should not be pencil")
        @unknown default:
            fatalError("PKInkingTool is not a pen or marker")
        }
    }

    mutating func switchAnnotationColor(_ newColor: UIColor) {
        guard let inkingTool = selectedTool as? PKInkingTool else {
            return
        }

        // Only pen and and marker (highlighter) inking tools used
        switch inkingTool.inkType {
        case .pen:
            selectedTool = PKInkingTool(.pen, color: newColor, width: inkingTool.width)
        case .marker:
            selectedTool = PKInkingTool(.marker, color: newColor, width: inkingTool.width)
        case .pencil:
            fatalError("PKInkingTool should not be pencil")
        @unknown default:
            fatalError("PKInkingTool is not a pen or marker")
        }
    }
}
