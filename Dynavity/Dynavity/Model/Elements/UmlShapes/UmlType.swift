// TODO: look into removing codable for this and updating DTO to store a primitive instead
enum UmlType: Int, Codable {
    // TODO: Add more UML Diagram Types
    case classDiagram, activityDiagram
}
