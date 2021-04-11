import Combine
import SwiftUI

class TodoItemViewModel: ObservableObject {
    @Published var todo: Todo
    private var todoCancellable: AnyCancellable?

    init(todo: Todo) {
        self.todo = todo
        self.todoCancellable = todo.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }
    }

    func toggleIsCompleted() {
        todo.isCompleted.toggle()
    }
}
