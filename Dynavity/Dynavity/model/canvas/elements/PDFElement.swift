import SwiftUI

struct PDFElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var observers = [ElementChangeListener]()

    var file: URL {
        didSet { notifyObservers() }
    }
}

extension PDFElement: Codable {
    private enum CodingKeys: CodingKey {
        case id, position, width, height, rotation, file
    }
}
