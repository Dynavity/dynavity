import SwiftUI

struct CanvasSelectionView: View {
    enum SelectionMode {
        case grid
        case graph
    }
    // TODO: Use actual canvas model instead, this is a temporary substitute
    struct CanvasDetail: Hashable {
        var title: String
        var isSelected: Bool
    }

    @State var canvases: [CanvasDetail]
    @State private var searchQuery: String = ""
    @State private var isEditing = false
    @State private var selectionMode: SelectionMode = .grid

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var filteredCanvases: [CanvasDetail] {
        canvases.filter {
            if searchQuery.isEmpty {
                return true
            }
        return $0.title.lowercased().contains(self.searchQuery.lowercased())
        }
    }

    var noCanvasSelected: Bool {
        canvases.allSatisfy {
            !$0.isSelected
        }
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
                    GraphView()
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
                    CanvasThumbnailView(canvasName: canvas.title, isSelected: canvas.isSelected)
                        .onTapGesture {
                            toggleSelectedCanvas(canvas.title)
                        }
                } else {
                    NavigationLink(destination: MainView()
                                    .navigationBarHidden(true)
                                    .navigationBarBackButtonHidden(true)) {
                        CanvasThumbnailView(canvasName: canvas.title, isSelected: canvas.isSelected)
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
                if selectionMode == .grid {
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
        CanvasSelectionView(canvases: [])
    }
}

extension CanvasSelectionView {
    func toggleEditMode() {
        isEditing.toggle()

        if !isEditing {
            clearSelectedCanvases()
        }
    }

    func toggleSelectedCanvas(_ title: String) {
        canvases = canvases.map {
            if $0.title == title {
                return CanvasSelectionView.CanvasDetail(title: $0.title,
                                                        isSelected: !$0.isSelected)
            }
            return $0
        }
    }

    func clearSelectedCanvases() {
        canvases = canvases.map {
            CanvasSelectionView.CanvasDetail(title: $0.title, isSelected: false)
        }
    }

    func deleteSelectedCanvases() {
        canvases = canvases.compactMap {
            if $0.isSelected {
                return nil
            }
            return CanvasSelectionView.CanvasDetail(title: $0.title, isSelected: false)
        }
    }
}
