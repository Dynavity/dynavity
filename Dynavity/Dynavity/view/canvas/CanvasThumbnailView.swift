import SwiftUI

struct CanvasThumbnailView: View {
    var canvasName: String
    var isSelected: Bool
    var body: some View {
        VStack {
            // TODO: replace this with canvas thumbnail
            Image(systemName: "doc")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 70)
                .overlay(isSelected ? checkSymbol : nil)
            Text(canvasName)
        }
    }

    var checkSymbol: some View {
        Image(systemName: "checkmark.circle")
            .scaleEffect(1.5)
            .foregroundColor(Color.blue)
    }
}

struct CanvasThumbnailView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasThumbnailView(canvasName: "", isSelected: false)
    }
}
