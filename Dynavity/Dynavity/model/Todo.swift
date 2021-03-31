struct Todo {
    var label: String
    var isCompleted = false
}

// MARK: Hashable
extension Todo: Hashable {}
