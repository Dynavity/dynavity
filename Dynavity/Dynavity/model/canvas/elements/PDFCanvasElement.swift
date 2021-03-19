import SwiftUI

struct PDFCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint = .zero
    var url: URL
}

// MARK: Equatable
extension PDFCanvasElement: Equatable {}
