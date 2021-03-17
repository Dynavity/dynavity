import SwiftUI

struct ImageCanvasElementView: View {
    var imageCanvasElement: ImageCanvasElement

    var body: some View {
        Image(uiImage: imageCanvasElement.image)
    }
}

struct ImageCanvasElementView_Previews: PreviewProvider {
    static let imageCanvasElement = ImageCanvasElement(image: UIImage())

    static var previews: some View {
        ImageCanvasElementView(imageCanvasElement: imageCanvasElement)
    }
}
