import SwiftUI

class ImageElementViewModel: ObservableObject {
    @Published var imageCanvasElement: ImageElement

    init(imageCanvasElement: ImageElement) {
        self.imageCanvasElement = imageCanvasElement
    }
}
