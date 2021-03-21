import SwiftUI

struct ImageCanvasElementView: View {
    @StateObject private var viewModel: ImageCanvasElementViewModel

    init(imageCanvasElement: ImageCanvasElement) {
        self._viewModel = StateObject(wrappedValue: ImageCanvasElementViewModel(imageCanvasElement: imageCanvasElement))
    }

    var body: some View {
        Image(uiImage: viewModel.imageCanvasElement.image)
    }
}

struct ImageCanvasElementView_Previews: PreviewProvider {
    static let imageCanvasElement = ImageCanvasElement(position: .zero, image: UIImage())

    static var previews: some View {
        ImageCanvasElementView(imageCanvasElement: imageCanvasElement)
    }
}
