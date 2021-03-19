import SwiftUI

struct HomeView: View {
    // TODO: replace this with list of actual canvases
    @State var canvases: [String] = (1...100).map { "Canvas \($0)" }

    var body: some View {
        CanvasSelectionView(canvases: $canvases)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
