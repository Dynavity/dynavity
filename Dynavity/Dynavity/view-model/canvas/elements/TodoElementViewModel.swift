import SwiftUI

class TodoElementViewModel: ObservableObject {
    @Published var todoElement: TodoElement

    var todos: [Todo] {
        todoElement.todos
    }

    init(todoElement: TodoElement) {
        self.todoElement = todoElement
    }

    func removeTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else {
            return
        }
        todoElement.removeTodo(at: index)
    }

    func addTodo(label: String) {
        todoElement.addTodo(label: label)
    }
}
