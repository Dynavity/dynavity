import SwiftUI

class TodoElementViewModel: ObservableObject {
    @Published var todoElement: TodoElement

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

    func getTodos() -> [Todo] {
        todoElement.todos
    }
}
