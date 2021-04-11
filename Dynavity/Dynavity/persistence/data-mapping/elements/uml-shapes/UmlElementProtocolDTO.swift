import Foundation

protocol UmlElementProtocolDTO: CanvasElementProtocolDTO {
    // For storing UML connectors
    var id: UUID { get }
}
