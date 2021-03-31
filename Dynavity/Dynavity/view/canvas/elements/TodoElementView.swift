import SwiftUI

struct TodoElementView: View {
    private let addButtonHeight: CGFloat = 45.0

    @StateObject private var viewModel: TodoElementViewModel

    init(todoElement: TodoElement) {
        self._viewModel = StateObject(wrappedValue: TodoElementViewModel(todoElement: todoElement))
    }

    private var addTodoButton: some View {
        Button(action: {
            viewModel.addNewTodo()
        }) {
            HStack {
                Image(systemName: "plus")
                    .foregroundColor(Color.blue)
                Text("Add a new To-Do")
            }
            .frame(height: addButtonHeight)
        }
    }

    var body: some View {
        // List cannot be used as it consumes touch events.
        ScrollView {
            // Necessary to remove the spacing between child views inherent to ScrollView.
            LazyVStack(spacing: 0.0) {
                ForEach(viewModel.todos, id: \.id) { todo in
                    TodoItemView(todo: todo, onDelete: { viewModel.removeTodo(todo) })
                    Divider()
                }
                addTodoButton
            }
        }
    }
}

struct TodoElementView_Previews: PreviewProvider {
    static var previews: some View {
        TodoElementView(todoElement: TodoElement(position: .zero))
    }
}
