import SwiftUI

struct HomeView: View {
    // TODO: replace this with list of actual canvases
    @State var canvases: [CanvasSelectionView.CanvasDetail] = (1...100)
        .map { CanvasSelectionView.CanvasDetail(title: "Canvas \($0)", isSelected: false) }

    var body: some View {
        CanvasSelectionView(canvases: $canvases,
                            toggleSelectedCanvas: toggleSelectedCanvas,
                            clearSelectedCanvases: clearSelectedCanvases)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

extension HomeView {
    func toggleSelectedCanvas(title: String) {
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
