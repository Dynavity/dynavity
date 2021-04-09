import SwiftUI

struct CanvasSelectionView: View {
    enum SelectionMode {
        case grid
        case graph
    }

    private let canvasRepo = CanvasRepository()
    var canvases: [Canvas] {
        canvasRepo.queryAll()
    }
    @State var selectedCanvases: [Canvas] = []
    @State private var searchQuery: String = ""
    @State private var isEditing = false
    @State private var selectionMode: SelectionMode = .grid

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var filteredCanvases: [Canvas] {
        canvases.filter {
            if searchQuery.isEmpty {
                return true
            }
        return $0.name.lowercased().contains(self.searchQuery.lowercased())
        }
    }

    var noCanvasSelected: Bool {
        selectedCanvases.isEmpty
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
                    GraphView(searchQuery: $searchQuery)
                }
            }
            .navigationBarHidden(true)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    var canvasesGrid: some View {
        LazyVGrid(columns: columns, spacing: 200) {
            ForEach(self.filteredCanvases, id: \.self) { canvas in
                if isEditing {
                    CanvasThumbnailView(canvasName: canvas.name, isSelected: isCanvasSelected(canvas))
                        .onTapGesture {
                            toggleSelectedCanvas(canvas)
                        }
                } else {
                    NavigationLink(destination: MainView()
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)) {
                        CanvasThumbnailView(canvasName: canvas.name, isSelected: isCanvasSelected(canvas))
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
                    deleteSelectedCanvases()
                    toggleEditMode()
                }) {
                    Image(systemName: "trash")
                }.disabled(noCanvasSelected)

                SearchBarView(text: $searchQuery)
            } else {
                if selectionMode != .graph {
                    Button("Edit") {
                        toggleEditMode()
                    }
                }
                SearchBarView(text: $searchQuery)
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
            clearSelectedCanvases()
        }
    }

    func toggleSelectedCanvas(_ canvas: Canvas) {
        let wasCanvasSelected = isCanvasSelected(canvas)
        if wasCanvasSelected {
            selectedCanvases.filter({ $0 != canvas })
        } else {
            selectedCanvases.append(canvas)
        }
    }

    func isCanvasSelected(_ canvas: Canvas) -> Bool {
        selectedCanvases.contains(canvas)
    }

    func clearSelectedCanvases() {
        selectedCanvases = []
    }

    func deleteSelectedCanvases() -> Bool {
        canvasRepo.deleteMany(models: selectedCanvases)
    }
}
