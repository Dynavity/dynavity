import SwiftUI

struct CanvasThumbnailView: View {
    var body: some View {
        VStack {
            // TODO: replace this with canvas thumbnail
            Image(systemName: "doc")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70)
            Text("Canvas Name")
        }
    }
}

struct CanvasThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasThumbnailView()
    }
}
