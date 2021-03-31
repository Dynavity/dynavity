import SwiftUI

struct TodoElement: CanvasElementProtocol {
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var minimumWidth: CGFloat {
        240.0
    }
    var minimumHeight: CGFloat {
        60.0
    }

    // MARK: TodosElement-specific attributes
    var todos: [Todo] = []
}
