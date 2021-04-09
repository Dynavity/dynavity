import SwiftUI

class UmlElementViewModel: ObservableObject {
    @Published var umlElement: UmlElementProtocol
    let shapeBorderWidth: CGFloat = 1.0

    init(umlElement: UmlElementProtocol) {
        self.umlElement = umlElement
    }
}
