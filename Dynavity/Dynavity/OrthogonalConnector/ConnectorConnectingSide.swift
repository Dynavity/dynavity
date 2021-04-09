// TODO: look into removing codable for this and updating DTO to store a primitive instead
/**
 Side of the `UmlElementProtocol` on which the uml diagram connector connects to.
 
 This is used as part of the algorithm to find the orthogonal diagram connector routing between UmlElements.
 */
enum ConnectorConnectingSide: Int, Codable {
    // Can possibly add more connecting sides
    case middleLeft
    case middleRight
    case middleTop
    case middleBottom
}
