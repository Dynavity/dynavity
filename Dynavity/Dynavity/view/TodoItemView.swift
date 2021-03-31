import SwiftUI

struct TodoItemView: View {
    private let checkboxSize: CGFloat = 35.0
    private let checkboxBorder: CGFloat = 1.0
    private let deleteButtonWidth: CGFloat = 50.0
    private let swipeInertia: CGFloat = 10.0

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
                    updatedSwipeOffset /= swipeInertia
                } else if updatedSwipeOffset < -deleteButtonWidth {
                    updatedSwipeOffset += deleteButtonWidth
                    updatedSwipeOffset /= swipeInertia
                    updatedSwipeOffset -= deleteButtonWidth
                }
                swipeOffset = updatedSwipeOffset
            }
            .onEnded { _ in
                withAnimation {
                    if swipeOffset < -deleteButtonWidth {
                        swipeOffset = -deleteButtonWidth
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
                    .strokeBorder(Color.gray, lineWidth: checkboxBorder)
                    .background(
                        Circle()
                            .foregroundColor(viewModel.todo.isCompleted ? Color.green : Color.clear)
                    )
                    .frame(width: checkboxSize, height: checkboxSize)
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
                        .frame(width: deleteButtonWidth)
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
            TextField("", text: $viewModel.todo.label, onEditingChanged: { isFocused in
                let trimmedLabel = viewModel.todo.label.trimmingCharacters(in: .whitespacesAndNewlines)
                if !isFocused && trimmedLabel.isEmpty {
                    withAnimation {
                        onDelete()
                    }
                }
            })
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
