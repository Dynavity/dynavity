import SwiftUI

class TodoElementViewModel: ObservableObject {
    @Published var todoElement: TodoElement

    init(todoElement: TodoElement) {
        self.todoElement = todoElement
    }
}
