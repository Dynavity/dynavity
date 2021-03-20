import SwiftUI

struct PDFCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint = .canvasCenter
    var file: URL
}

// MARK: Equatable
extension PDFCanvasElement: Equatable {}
