import SwiftUI

struct TodoItemView: View {
    var todo: Todo

    var body: some View {
        HStack {
            Text(todo.label)
        }
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static let todo = Todo(label: "CS3217 Sprint Report")

    static var previews: some View {
        TodoItemView(todo: todo)
    }
}
