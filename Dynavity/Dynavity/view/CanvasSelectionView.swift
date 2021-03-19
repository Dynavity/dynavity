import SwiftUI

struct CanvasSelectionView: View {
    // TODO: replace this with list of canvases
    let data = (1...100).map { "Item \($0)" }

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 200) {
                ForEach(data, id: \.self) { _ in
                    CanvasThumbnailView()
                }
            }
            .padding(.horizontal)
        }
    }
}

struct CanvasSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSelectionView()
    }
}
