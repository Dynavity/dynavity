import Foundation
import SwiftUI

class OnlineCanvas: Canvas {
    static let myUserId = UIDevice.current.identifierForVendor?.uuidString
            ?? "NO_USER_ID"

    let id: UUID
    let ownerId: String
    var shareableId: String {
        "\(ownerId)/\(id)"
    }

    /// Used to publish a user's `CanvasWithAnnotation` as an `OnlineCanvas`.
    override convenience init(canvas: Canvas) {
        self.init(id: UUID(), ownerId: OnlineCanvas.myUserId, canvas: canvas)
    }

    /// Used to import another user's `OnlineCanvas`.
    init(id: UUID, ownerId: String, canvas: Canvas) {
        self.id = id
        self.ownerId = ownerId
        super.init(canvas: canvas)
    }
}
