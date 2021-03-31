import SwiftUI

struct TodoElementView: View {
    @StateObject private var viewModel: TodoElementViewModel

    init(todoElement: TodoElement) {
        self._viewModel = StateObject(wrappedValue: TodoElementViewModel(todoElement: todoElement))
    }

    var body: some View {
        // List cannot be used as it consumes touch events.
        ScrollView {
            // Necessary to remove the spacing between child views inherent to ScrollView.
            VStack(spacing: 0.0) {
                ForEach(viewModel.getTodos(), id: \.self) { todo in
                    TodoItemView(todo: todo)
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
