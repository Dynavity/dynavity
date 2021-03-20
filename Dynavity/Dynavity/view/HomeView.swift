import SwiftUI

struct HomeView: View {
    // TODO: replace this with list of actual canvases
    var canvases: [CanvasSelectionView.CanvasDetail] = (1...100)
        .map { CanvasSelectionView.CanvasDetail(title: "Canvas \($0)", isSelected: false) }

    var body: some View {
        CanvasSelectionView(canvases: canvases)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
