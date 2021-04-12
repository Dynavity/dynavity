import Foundation
import SwiftUI

class OnlineCanvas: CanvasWithAnnotation {
    static let myUserId = UIDevice.current.identifierForVendor?.uuidString
            ?? "NO_USER_ID"

    let ownerId: String

    /// Used to publish a user's `CanvasWithAnnotation` as an `OnlineCanvas`.
    convenience init(canvas: CanvasWithAnnotation) {
        self.init(ownerId: OnlineCanvas.myUserId, canvas: canvas)
    }

    /// Used to import another user's `OnlineCanvas`.
    init(ownerId: String, canvas: CanvasWithAnnotation) {
        self.ownerId = ownerId
        super.init(canvas: canvas.canvas, annotationCanvas: canvas.annotationCanvas)
    }
}
