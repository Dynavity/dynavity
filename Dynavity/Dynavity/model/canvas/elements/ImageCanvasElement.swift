import SwiftUI

struct ImageCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var image: UIImage
    var width: CGFloat
    var height: CGFloat

    init(position: CGPoint, image: UIImage) {
        self.position = position
        self.image = image
        self.width = image.size.width
        self.height = image.size.height
    }
}

// MARK: Equatable
extension ImageCanvasElement: Equatable {}
