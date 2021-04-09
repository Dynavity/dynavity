import PencilKit

struct AnnotationPalette {
    enum SelectedTool {
        case pen
        case marker
        case eraser
        case lasso
    }

    static let annotationWidths: [CGFloat] = [3, 6, 9, 12]
    static let annotationColors = [UIColor.blue, UIColor.red, UIColor.green, UIColor.yellow]
    private var penTool = PKInkingTool(.pen, color: .blue, width: annotationWidths[2])
    private var markerTool = PKInkingTool(.marker, color: .yellow, width: annotationWidths[2])
    private var selectedTool: SelectedTool

    init() {
        selectedTool = .pen
    }

    mutating func switchTool(_ newTool: SelectedTool) {
        selectedTool = newTool
    }

    func getSelectedTool() -> PKTool {
        switch selectedTool {
        case .pen:
            return penTool
        case .marker:
            return markerTool
        case .eraser:
            return PKEraserTool(.vector)
        case .lasso:
            return PKLassoTool()
        }
    }

    mutating func setAnnotationWidth(_ newWidth: CGFloat) {
        switch selectedTool {
        case .pen:
            penTool.width = newWidth
        case .marker:
            markerTool.width = newWidth
        default:
            assertionFailure("Attempt at setting annotation width of a non-inking tool.")
        }
    }

    mutating func setAnnotationColor(_ newColor: UIColor) {
        switch selectedTool {
        case .pen:
            penTool.color = newColor
        case .marker:
            markerTool.color = newColor
        default:
            assertionFailure("Attempt at setting annotation color of a non-inking tool.")
        }
    }
}
