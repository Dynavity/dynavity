import Combine
import SwiftUI

class ImageElement: ObservableObject, CanvasElementProtocol {
    @Published var canvasProperties: CanvasElementProperties
    private var codeImage: CodableImage

    var image: UIImage {
        codeImage.image
    }

    init(position: CGPoint, image: UIImage) {
        self.canvasProperties = CanvasElementProperties(
            position: position,
            width: image.size.width,
            height: image.size.height
        )
        self.codeImage = CodableImage(image: image)
    }
}
