import Foundation
import SwiftUI

class OnlineCanvas: Canvas {
    static let myUserId = UIDevice.current.identifierForVendor?.uuidString
            ?? "NO_USER_ID"

    let ownerId: String

    /// Used to publish a user's `Canvas` as an `OnlineCanvas`.
    override convenience init(canvas: Canvas) {
        self.init(ownerId: OnlineCanvas.myUserId, canvas: canvas)
    }

    /// Used to import another user's `OnlineCanvas`.
    init(ownerId: String, canvas: Canvas) {
        self.ownerId = ownerId
        super.init(canvas: canvas)
    }
}
