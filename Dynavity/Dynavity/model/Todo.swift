import SwiftUI

struct Todo {
    let id = UUID()
    var label: String
    var isCompleted = false
}

// MARK: Hashable
extension Todo: Hashable {}
