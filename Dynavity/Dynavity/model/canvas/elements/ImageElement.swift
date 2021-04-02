import SwiftUI

struct ImageElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    private var codeImage: CodableImage
    var width: CGFloat
    var height: CGFloat
    var rotation: Double = .zero

    var image: UIImage {
        codeImage.image
    }

    init(position: CGPoint, image: UIImage) {
        self.position = position
        self.codeImage = CodableImage(image: image)
        self.width = image.size.width
        self.height = image.size.height
    }
}

// MARK: Equatable
extension ImageElement: Equatable {}
