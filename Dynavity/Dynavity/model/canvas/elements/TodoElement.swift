import SwiftUI

struct TodoElement: CanvasElementProtocol {
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat
    var height: CGFloat
    var rotation: Double = .zero

    // MARK: TodosElement-specific attributes
    var todos: [Todo] = []
}
