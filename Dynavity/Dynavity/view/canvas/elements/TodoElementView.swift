import SwiftUI

struct TodoElementView: View {
    @ObservedObject private var viewModel: TodoElementViewModel

    init(todoElement: TodoElement) {
        self.viewModel = TodoElementViewModel(todoElement: todoElement)
    }

    var body: some View {
        // List cannot be used as it consumes touch events.
        ScrollView {
            // Necessary to remove the spacing between child views inherent to ScrollView.
            VStack(spacing: 0.0) {
                ForEach(viewModel.todos, id: \.id) { todo in
                    TodoItemView(todo: todo, onDelete: { viewModel.removeTodo(todo) })
                    Divider()
                }
            }
        }
    }
}

struct TodoElementView_Previews: PreviewProvider {
    static var previews: some View {
        TodoElementView(todoElement: TodoElement(position: .zero))
    }
}
