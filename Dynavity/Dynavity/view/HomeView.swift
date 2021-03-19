import SwiftUI

struct HomeView: View {
    // TODO: replace this with list of actual canvases
    @State var canvases: [String] = (1...100).map { "Canvas \($0)" }
    @State var searchQuery: String = ""

    var body: some View {
        SearchBar(text: .constant(""))
            .padding()
        CanvasSelectionView(canvases: $canvases)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
