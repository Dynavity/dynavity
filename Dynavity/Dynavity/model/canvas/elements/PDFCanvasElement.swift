import SwiftUI

struct PDFCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var file: URL
}

// MARK: Equatable
extension PDFCanvasElement: Equatable {}
