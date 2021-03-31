import SwiftUI

struct TodoElementView: View {
    @StateObject private var viewModel: TodoElementViewModel

    init(todoElement: TodoElement) {
        self._viewModel = StateObject(wrappedValue: TodoElementViewModel(todoElement: todoElement))
    }

    var body: some View {
        List {
            ForEach(viewModel.getTodos(), id: \.self) { todo in
                TodoItemView(todo: todo)
            }
        }
    }
}

struct TodoElementView_Previews: PreviewProvider {
    static var previews: some View {
        TodoElementView(todoElement: TodoElement(position: .zero))
    }
}
