import SwiftUI

struct ImageCanvasElementView: View {
    @ObservedObject var viewModel: ImageCanvasElementViewModel

    init(imageCanvasElement: ImageCanvasElement) {
        self.viewModel = ImageCanvasElementViewModel(imageCanvasElement: imageCanvasElement)
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
