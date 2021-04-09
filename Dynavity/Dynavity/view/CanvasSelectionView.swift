import SwiftUI

struct CanvasSelectionView: View {
    enum SelectionMode {
        case grid
        case graph
    }

    @StateObject private var viewModel = CanvasSelectionViewModel()
    @State private var isEditing = false
    @State private var selectionMode: SelectionMode = .grid

    let columns = [
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

    var canvasesGrid: some View {
        LazyVGrid(columns: columns, spacing: 200) {
            ForEach(viewModel.getFilteredCanvases(), id: \.self) { canvas in
                if isEditing {
                    CanvasThumbnailView(canvasName: canvas.name,
                                        isSelected: viewModel.isCanvasSelected(canvas))
                        .onTapGesture {
                            viewModel.toggleSelectedCanvas(canvas)
                        }
                } else {
                    NavigationLink(destination: MainView()
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)) {
                        CanvasThumbnailView(canvasName: canvas.name,
                                            isSelected: viewModel.isCanvasSelected(canvas))
                    }
                }
            }
        }
        .padding(.horizontal)
    }

    var selectionModeToggleButton: some View {
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

    var actionButtonGroup: some View {
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
    func toggleEditMode() {
        isEditing.toggle()

        if !isEditing {
            viewModel.clearSelectedCanvases()
        }
    }
}
