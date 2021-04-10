/**
 Side of the `UmlElementProtocol` on which the uml diagram connector connects to.
 
 This is used as part of the algorithm to find the orthogonal diagram connector routing between UmlElements.
 */
enum ConnectorConnectingSide: String {
    // Can possibly add more connecting sides
    case middleLeft
    case middleRight
    case middleTop
    case middleBottom
}
