import Combine
import SwiftUI

class TodoElement: ObservableObject, CanvasElementProtocol {
    // MARK: CanvasElementProtocol
    @Published var canvasProperties: CanvasElementProperties

    // MARK: TodosElement-specific attributes
    var todos: [Todo]
    private var todoCancellables: [AnyCancellable]

    init(position: CGPoint) {
        self.canvasProperties = CanvasElementProperties(
            position: position,
            minimumWidth: 240.0,
            minimumHeight: 60.0
        )
        self.todos = []
        self.todoCancellables = []
    }

    func removeTodo(at index: Int) {
        todos.remove(at: index)
        todoCancellables.remove(at: index)
    }

    func addTodo(label: String) {
        let todo = Todo(label: label)
        todos.append(todo)
        let cancellable = todo.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
        todoCancellables.append(cancellable)
    }
}
