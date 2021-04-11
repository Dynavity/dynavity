import Combine
import SwiftUI

class TodoElementViewModel: ObservableObject {
    @Published var todoElement: TodoElement
    private var todoElementCancellable: AnyCancellable?

    var todos: [Todo] {
        todoElement.todos
    }

    init(todoElement: TodoElement) {
        self.todoElement = todoElement
        self.todoElementCancellable = todoElement.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func removeTodo(_ todo: Todo) {
        todoElement.removeTodo(todo)
    }

    func addTodo(label: String) {
        todoElement.addTodo(label: label)
    }
}
