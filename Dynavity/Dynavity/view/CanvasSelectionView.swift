import SwiftUI

struct CanvasSelectionView: View {
    struct CanvasDetail: Hashable {
        var title: String
        var isSelected: Bool
    }

    @State var canvases: [CanvasDetail]
    @State var searchQuery: String = ""
    @State var isEditing = false

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
}
