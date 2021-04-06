import SwiftUI

struct AnyCanvasElementProtocol: Identifiable {
    var id: ObjectIdentifier {
        ObjectIdentifier(canvasElement)
    }
    let canvasElement: CanvasElementProtocol
}
