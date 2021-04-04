import SwiftUI

struct ImageElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var width: CGFloat
    var height: CGFloat
    var rotation: Double = .zero
    var observers = [ElementChangeListener]()

    private var codeImage: CodableImage {
        didSet { notifyObservers() }
    }
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

extension ImageElement: Codable {
    private enum CodingKeys: CodingKey {
        case id, position, width, height, rotation, codeImage
    }
}
