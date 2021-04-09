import Combine
import SwiftUI

class ImageElement: ObservableObject, CanvasElementProtocol {
    @Published var canvasProperties: CanvasElementProperties
    var image: UIImage

    init(position: CGPoint, image: UIImage) {
        self.canvasProperties = CanvasElementProperties(
            position: position,
            width: image.size.width,
            height: image.size.height
        )
        self.image = image
    }
}
