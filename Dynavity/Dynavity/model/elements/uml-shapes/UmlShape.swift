enum UmlShape: String {
    case rectangle, diamond

    var label: String {
        switch self {
        case .rectangle:
            return "Process"
        case .diamond:
            return "Decision"
        }
    }
}
