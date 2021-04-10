import SwiftUI

class ImageElementViewModel: ObservableObject {
    @Published var imageElement: ImageElement

    init(imageElement: ImageElement) {
        self.imageElement = imageElement
    }
}
