import SwiftUI

struct HomeView: View {
    // TODO: replace this with list of actual canvases
    @State var canvases: [String] = (1...100).map { "Canvas \($0)" }
    @State var searchQuery: String = ""

    init() {
        self.canvases = self.canvases.filter {
            if searchQuery.isEmpty {
                return true
            }
            return $0.lowercased().contains(self.searchQuery.lowercased())
        }
    }

    var body: some View {
        SearchBar(text: $searchQuery)
            .padding()
        CanvasSelectionView(canvases: $canvases, searchQuery: $searchQuery)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
