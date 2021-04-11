import Foundation

/**
 UmlElement wrapper that includes a unique ID. Used to ensure correct references for UmlConnectors.
 */
class IdentifiedUmlElementWrapper {
    let id: UmlElementId
    let umlElement: UmlElementProtocol

    init(id: UmlElementId, umlElement: UmlElementProtocol) {
        self.id = id
        self.umlElement = umlElement
    }
}
