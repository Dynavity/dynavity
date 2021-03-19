import SwiftUI

struct CanvasSelectionView: View {
    @Binding var canvases: [String]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 200) {
                ForEach(canvases, id: \.self) { canvas in
                    CanvasThumbnailView(canvasName: canvas)
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CanvasSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSelectionView(canvases: .constant([]))
    }
}
