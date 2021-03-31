import SwiftUI

class TodoElementViewModel: ObservableObject {
    @Published var todoElement: TodoElement

    var todos: [Todo] {
        todoElement.todos
    }

    init(todoElement: TodoElement) {
        self.todoElement = todoElement
        initialiseTestTodos()
    }

    // TODO: Remove this function.
    private func initialiseTestTodos() {
        for i in 1..<20 {
            todoElement.todos.append(Todo(label: "This is Todo #\(i)"))
        }
    }

    func removeTodo(_ todo: Todo) {
        guard let index = todos.firstIndex(of: todo) else {
            return
        }
        todoElement.removeTodo(at: index)
    }

    func addNewTodo() {
        todoElement.addEmptyTodo()
    }
}
