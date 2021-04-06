import SwiftUI

struct AnyUmlElementProtocol: Identifiable {
    var id: ObjectIdentifier {
        ObjectIdentifier(umlElement)
    }
    let umlElement: UmlElementProtocol
}
