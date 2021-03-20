import SwiftUI

struct PDFCanvasElement: CanvasElementProtocol {
    var id = UUID()
    var position: CGPoint
    var file: URL
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
}

// MARK: Equatable
extension PDFCanvasElement: Equatable {}
