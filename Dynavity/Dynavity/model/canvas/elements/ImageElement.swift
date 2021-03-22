import SwiftUI

struct ImageElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var image: UIImage
    var width: CGFloat
    var height: CGFloat
    var rotation: Double = .zero

    init(position: CGPoint, image: UIImage) {
        self.position = position
        self.image = image
        self.width = image.size.width
        self.height = image.size.height
    }
}

// MARK: Equatable
extension ImageElement: Equatable {}
