import SwiftUI

struct CanvasSelectionView: View {
    @Binding var canvases: [String]
    @State var searchQuery: String = ""

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var filteredCanvases: [String] {
        canvases.filter {
            if searchQuery.isEmpty {
                return true
            }
            return $0.lowercased().contains(self.searchQuery.lowercased())
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchQuery)
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
                NavigationLink(destination: MainView()
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)) {
                    CanvasThumbnailView(canvasName: canvas)
                }
            }
        }
        .padding(.horizontal)
    }
}

struct CanvasSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasSelectionView(canvases: .constant([]))
    }
}
