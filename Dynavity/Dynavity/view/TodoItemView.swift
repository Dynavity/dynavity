import SwiftUI

struct TodoItemView: View {
    static let checkboxSize: CGFloat = 35.0
    static let checkboxBorder: CGFloat = 1.0
    static let deleteButtonWidth: CGFloat = 50.0
    static let swipeInertia: CGFloat = 10.0

    @StateObject private var viewModel: TodoItemViewModel
    @State private var swipeOffset: CGFloat = .zero
    private let onDelete: () -> Void

    init(todo: Todo, onDelete: @escaping () -> Void) {
        self._viewModel = StateObject(wrappedValue: TodoItemViewModel(todo: todo))
        self.onDelete = onDelete
    }

    private var swipeGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                var updatedSwipeOffset = value.translation.width
                if updatedSwipeOffset > .zero {
                    updatedSwipeOffset /= TodoItemView.swipeInertia
                } else if updatedSwipeOffset < -TodoItemView.deleteButtonWidth {
                    updatedSwipeOffset += TodoItemView.deleteButtonWidth
                    updatedSwipeOffset /= TodoItemView.swipeInertia
                    updatedSwipeOffset -= TodoItemView.deleteButtonWidth
                }
                swipeOffset = updatedSwipeOffset
            }
            .onEnded { _ in
                withAnimation {
                    if swipeOffset < -TodoItemView.deleteButtonWidth {
                        swipeOffset = -TodoItemView.deleteButtonWidth
                    } else {
                        swipeOffset = 0.0
                    }
                }
            }
    }

    private var checkbox: some View {
        Button(action: {
            withAnimation(Animation.easeInOut(duration: 0.5)) {
                viewModel.toggleIsCompleted()
            }
        }) {
            ZStack {
                Circle()
                    .strokeBorder(Color.gray, lineWidth: TodoItemView.checkboxBorder)
                    .background(
                        Circle()
                            .foregroundColor(viewModel.todo.isCompleted ? Color.green : Color.clear)
                    )
                    .frame(width: TodoItemView.checkboxSize, height: TodoItemView.checkboxSize)
                Image(systemName: "checkmark")
                    .foregroundColor(Color.white)
                    .opacity(viewModel.todo.isCompleted ? 1.0 : 0.0)
            }
        }
        // Disable flashing when tapped.
        .buttonStyle(PlainButtonStyle())
    }

    private var deleteButton: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: geometry.size.width)
                HStack {
                    Image(systemName: "trash")
                        .foregroundColor(Color.white)
                        .frame(width: TodoItemView.deleteButtonWidth)
                    Spacer()
                }
            }
            .offset(x: geometry.size.width)
            .onTapGesture {
                withAnimation {
                    onDelete()
                }
            }
        }
    }

    var body: some View {
        HStack {
            checkbox
                .padding(.leading, 5.0)
            TextField("", text: $viewModel.todo.label)
                .foregroundColor(viewModel.todo.isCompleted ? Color.gray : Color.black)
        }
        .padding(5.0)
        .overlay(deleteButton)
        .offset(x: swipeOffset)
        .gesture(swipeGesture)
    }
}

struct TodoItemView_Previews: PreviewProvider {
    static let todo = Todo(label: "CS3217 Sprint Report")

    static var previews: some View {
        TodoItemView(todo: todo, onDelete: {})
    }
}
