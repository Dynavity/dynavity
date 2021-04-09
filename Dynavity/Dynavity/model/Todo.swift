import SwiftUI

struct Todo {
    var id = UUID()
    var label: String
    var isCompleted = false
}

// MARK: Hashable
extension Todo: Hashable {}
