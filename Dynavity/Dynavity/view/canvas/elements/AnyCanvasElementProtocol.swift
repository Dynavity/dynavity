import SwiftUI

struct AnyCanvasElementProtocol: Identifiable {
    let id = UUID()
    let canvasElement: CanvasElementProtocol
}
