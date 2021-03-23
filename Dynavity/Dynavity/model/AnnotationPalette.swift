import PencilKit

struct AnnotationPalette {
    private let defaultTool = PKInkingTool(.pen, color: .blue, width: 10)

    var selectedTool: PKTool

    init() {
        selectedTool = defaultTool
    }

    mutating func switchTool(_ newTool: PKTool) {
        selectedTool = newTool
    }
}
