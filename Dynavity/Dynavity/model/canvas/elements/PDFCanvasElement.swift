import SwiftUI

struct PDFCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint = .zero
    var file: URL
}

// MARK: Equatable
extension PDFCanvasElement: Equatable {}
