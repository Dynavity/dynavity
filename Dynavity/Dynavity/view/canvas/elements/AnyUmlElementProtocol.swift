import SwiftUI

struct AnyUmlElementProtocol: Identifiable {
    let id = UUID()
    let umlElement: UmlElementProtocol
}
