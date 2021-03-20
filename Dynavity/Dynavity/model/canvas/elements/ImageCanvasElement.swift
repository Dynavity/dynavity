import SwiftUI

struct ImageCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var image: UIImage
}

// MARK: Equatable
extension ImageCanvasElement: Equatable {}
