import SwiftUI

struct TodoElementView: View {
    private let addTodoButtonSize: CGFloat = 35.0

    @StateObject private var viewModel: TodoElementViewModel
    @State private var newTodoLabel: String = ""

    private var trimmedNewTodoLabel: String {
        newTodoLabel.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var isAddTodoButtonDisabled: Bool {
        trimmedNewTodoLabel.isEmpty
    }

    init(todoElement: TodoElement) {
        self._viewModel = StateObject(wrappedValue: TodoElementViewModel(todoElement: todoElement))
    }

    private var addTodoControl: some View {
        HStack {
            Button(action: {
                viewModel.addTodo(label: trimmedNewTodoLabel)
                newTodoLabel = ""
            }) {
                Image(systemName: "plus.circle")
                    .resizable()
                    .foregroundColor(isAddTodoButtonDisabled ? Color.gray : Color.blue)
                    .frame(width: addTodoButtonSize, height: addTodoButtonSize)
            }
            .padding(.leading, 5.0)
            .disabled(isAddTodoButtonDisabled)
            TextField("Add a new To-Do", text: $newTodoLabel)
        }
        .padding(5.0)
    }

    var body: some View {
        // List cannot be used as it consumes touch events.
        ScrollView {
            // Necessary to remove the spacing between child views inherent to ScrollView.
            LazyVStack(spacing: 0.0) {
                ForEach(viewModel.todos, id: \.self) { todo in
                    TodoItemView(todo: todo, onDelete: { viewModel.removeTodo(todo) })
                    Divider()
                }
                addTodoControl
            }
        }
    }
}

struct TodoElementView_Previews: PreviewProvider {
    static var previews: some View {
        TodoElementView(todoElement: TodoElement(position: .zero))
    }
}
