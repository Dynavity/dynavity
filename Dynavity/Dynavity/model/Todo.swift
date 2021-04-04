import SwiftUI

struct Todo: Codable {
    var id = UUID()
    var label: String
    var isCompleted = false
}

// MARK: Hashable
extension Todo: Hashable {}
