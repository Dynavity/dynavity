import Foundation
import SwiftUI

class OnlineCanvas: Canvas {
    static let myUserId = UIDevice.current.identifierForVendor?.uuidString
            ?? "NO_USER_ID"
    static let delimiter: Character = "/"

    let ownerId: String
    var shareableId: String {
        // note that since / is a delimiter, it must not appear in either field
        "\(ownerId)\(OnlineCanvas.delimiter)\(name)"
    }

    /// Used to publish a user's `CanvasWithAnnotation` as an `OnlineCanvas`.
    override convenience init(canvas: Canvas) {
        self.init(ownerId: OnlineCanvas.myUserId, canvas: canvas)
    }

    /// Used to import another user's `OnlineCanvas`.
    init(ownerId: String, canvas: Canvas) {
        self.ownerId = ownerId
        super.init(canvas: canvas)
    }
}
