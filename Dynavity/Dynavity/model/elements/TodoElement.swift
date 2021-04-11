import Combine
import SwiftUI

class TodoElement: ObservableObject, CanvasElementProtocol {
    // MARK: CanvasElementProtocol
    @Published var canvasProperties: CanvasElementProperties

    // MARK: TodoElement-specific attributes
    @Published private(set) var todos: [Todo]
    private var todoCancellables: [AnyCancellable]

    init(position: CGPoint, todos: [Todo]) {
        self.canvasProperties = CanvasElementProperties(
            position: position,
            minimumWidth: 240.0,
            minimumHeight: 60.0
        )
        self.todos = todos
        self.todoCancellables = []
        for todo in todos {
            let cancellable = todo.objectWillChange.sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            todoCancellables.append(cancellable)
        }
    }

    convenience init(position: CGPoint) {
        self.init(position: position, todos: [])
    }

    func removeTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(where: { $0 === todo }) else {
            return
        }
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
