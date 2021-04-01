import SwiftUI

class TodoItemViewModel: ObservableObject {
    @Published var todo: Todo

    init(todo: Todo) {
        self.todo = todo
    }

    func toggleIsCompleted() {
        todo.isCompleted.toggle()
    }
}
