import SwiftUI

struct CanvasSelectionView: View {
    @Binding var canvases: [String]
    @Binding var searchQuery: String

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 200) {
                let filteredCanvases = canvases.filter {
                    if searchQuery.isEmpty {
                        return true
                    }
                    return $0.lowercased().contains(self.searchQuery.lowercased())
                }
                ForEach(filteredCanvases, id: \.self) { canvas in
                    CanvasThumbnailView(canvasName: canvas)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CanvasSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSelectionView(canvases: .constant([]), searchQuery: .constant(""))
    }
}
