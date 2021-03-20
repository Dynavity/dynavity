import SwiftUI

struct CanvasSelectionView: View {
    struct CanvasDetail: Hashable {
        var title: String
        var isSelected: Bool
    }

    @Binding var canvases: [CanvasDetail]
    @State var searchQuery: String = ""
    @State var isEditing = false
    var toggleSelectedCanvas: (String) -> Void
    var clearSelectedCanvases: () -> Void

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

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button(isEditing ? "Done" : "Edit") {
                        toggleEditMode()
                    }
                    SearchBar(text: $searchQuery)
                }
                .padding()
                ScrollView {
                    canvasesGrid
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
}

struct CanvasSelectionView_Previews: PreviewProvider {
    static func toggle(input: String) {}
    static func clear() {}
    static var previews: some View {
        CanvasSelectionView(canvases: .constant([]),
                            toggleSelectedCanvas: toggle,
                            clearSelectedCanvases: clear)
    }
}

extension CanvasSelectionView {
    func toggleEditMode() {
        isEditing.toggle()

        if !isEditing {
            clearSelectedCanvases()
        }
    }
}
