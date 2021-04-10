import SwiftUI

struct CanvasSelectionView: View {
    private enum SelectionMode {
        case grid
        case graph
    }

    @StateObject private var viewModel = CanvasSelectionViewModel()
    @State private var isEditing = false
    @State private var selectionMode: SelectionMode = .grid

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var noCanvasSelected: Bool {
        viewModel.selectedCanvases.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack {
                actionButtonGroup
                .padding()
                switch selectionMode {
                case .grid:
                    ScrollView {
                        canvasesGrid
                    }
                case .graph:
                    GraphView(searchQuery: $viewModel.searchQuery)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    private var canvasesGrid: some View {
        LazyVGrid(columns: columns, spacing: 200) {
            ForEach(viewModel.getFilteredCanvases(), id: \.self) { canvas in
                if isEditing {
                    CanvasThumbnailView(canvasName: canvas.name,
                                        isSelected: viewModel.isCanvasSelected(canvas))
                        .onTapGesture {
                            viewModel.toggleSelectedCanvas(canvas)
                        }
                } else {
                    NavigationLink(destination: MainView(canvas: canvas)
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)) {
                        CanvasThumbnailView(canvasName: canvas.name,
                                            isSelected: viewModel.isCanvasSelected(canvas))

                    }
                    .contextMenu {
                        getContextMenuFor(canvas: canvas)
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    private func getContextMenuFor(canvas: Canvas) -> some View {
        Group {
            Button {
                onRenameButtonTap(canvas: canvas)
            } label: {
                Label("Rename", systemImage: "pencil")
            }

            Button {
                onDeleteButtonTap(canvas: canvas)
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var selectionModeToggleButton: some View {
        switch selectionMode {
        case .grid:
            return Button(action: {
                selectionMode = .graph
            }) {
                Image(systemName: "circle.grid.hex.fill")
            }
        case .graph:
            return Button(action: {
                selectionMode = .grid
            }) {
                Image(systemName: "square.grid.2x2.fill")
            }
        }
    }

    private var actionButtonGroup: some View {
        HStack {
            if isEditing {
                Button("Done") {
                    toggleEditMode()
                }
                Button(action: {
                    viewModel.deleteSelectedCanvases()
                    toggleEditMode()
                }) {
                    Image(systemName: "trash")
                }.disabled(noCanvasSelected)

                SearchBarView(text: $viewModel.searchQuery)
            } else {
                if selectionMode != .graph {
                    Button("Edit") {
                        toggleEditMode()
                    }
                }
                SearchBarView(text: $viewModel.searchQuery)
                // TODO: Implement saving the newly created canvas to state & db
                selectionModeToggleButton

                NavigationLink(destination: MainView()
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)) {
                    Image(systemName: "doc.fill.badge.plus")
                }
            }
        }
    }
}

struct CanvasSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSelectionView()
    }
}

extension CanvasSelectionView {
    private func toggleEditMode() {
        isEditing.toggle()

        if !isEditing {
            viewModel.clearSelectedCanvases()
        }
    }
}

// MAKR: Alert handlers
extension CanvasSelectionView {
    private func onRenameButtonTap(canvas: Canvas) {
        let alert = UIAlertController(title: "Rename canvas", message: nil, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = "\(canvas.name)"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { _ in
            guard let updatedName = alert.textFields?.first?.text else {
                return
            }

            let isNewNameUnique = viewModel.isCanvasNameUnique(name: updatedName)

            if isNewNameUnique {
                viewModel.renameCanvas(canvas, updatedName: updatedName)
            } else {
                invalidCanvasNameHandler(canvas: canvas)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.showAlert(alert: alert)
    }

    private func onDeleteButtonTap(canvas: Canvas) {
        let alert = UIAlertController(title: "Delete canvas",
                                      message: "This canvas will be deleted. This action cannot be undone.",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
            viewModel.deleteCanvas(canvas)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.showAlert(alert: alert)
    }

    private func invalidCanvasNameHandler(canvas: Canvas) {
        let errorAlert = UIAlertController(title: "Invalid canvas name!",
                                           message: "Canvas names must be unique.",
                                           preferredStyle: .alert)
         errorAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { _ in
            onRenameButtonTap(canvas: canvas)
         }))
        self.showAlert(alert: errorAlert)
    }
}
