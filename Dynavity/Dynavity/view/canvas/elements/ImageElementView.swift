import SwiftUI

struct ImageElementView: View {
    @StateObject private var viewModel: ImageElementViewModel

    init(imageElement: ImageElement) {
        self._viewModel = StateObject(wrappedValue: ImageElementViewModel(imageElement: imageElement))
    }

    var body: some View {
        Image(uiImage: viewModel.imageElement.image)
            .resizable()
    }
}

struct ImageElementView_Previews: PreviewProvider {
    static let imageElement = ImageElement(position: .zero, image: UIImage())

    static var previews: some View {
        ImageElementView(imageElement: imageElement)
    }
}
