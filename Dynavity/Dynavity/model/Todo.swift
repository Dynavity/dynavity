import SwiftUI

class Todo {
    var label: String
    var isCompleted: Bool

    init(label: String, isCompleted: Bool) {
        self.label = label
        self.isCompleted = isCompleted
    }

    convenience init(label: String) {
        self.init(label: label, isCompleted: false)
    }
}

// MARK: Hashable
extension Todo: Hashable {
    static func == (lhs: Todo, rhs: Todo) -> Bool {
        ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
