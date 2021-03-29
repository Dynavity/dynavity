import SwiftUI

struct ImageElementView: View {
    @StateObject private var viewModel: ImageElementViewModel

    init(imageCanvasElement: ImageElement) {
        self._viewModel = StateObject(wrappedValue: ImageElementViewModel(imageCanvasElement: imageCanvasElement))
    }

    var body: some View {
        Image(uiImage: viewModel.imageCanvasElement.image)
            .resizable()
    }
}

struct ImageElementView_Previews: PreviewProvider {
    static let imageCanvasElement = ImageElement(position: .zero, image: UIImage())

    static var previews: some View {
        ImageElementView(imageCanvasElement: imageCanvasElement)
    }
}
