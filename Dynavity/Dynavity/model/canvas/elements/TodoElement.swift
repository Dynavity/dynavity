import SwiftUI

class TodoElement: CanvasElementProtocol {
    // MARK: CanvasElementProtocol
    var canvasProperties: CanvasElementProperties

    // MARK: TodosElement-specific attributes
    var todos: [Todo] = []

    init(position: CGPoint) {
        self.canvasProperties = CanvasElementProperties(
            position: position,
            minimumWidth: 240.0,
            minimumHeight: 60.0
        )
    }

    func removeTodo(at index: Int) {
        todos.remove(at: index)
    }

    func addTodo(label: String) {
        todos.append(Todo(label: label))
    }
}
