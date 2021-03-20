import SwiftUI

struct CanvasThumbnailView: View {
    var canvasName: String
    var body: some View {
        VStack {
            // TODO: replace this with canvas thumbnail
            Image(systemName: "doc")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70)
            Text(canvasName)
        }
    }
}

struct CanvasThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasThumbnailView(canvasName: "")
    }
}
