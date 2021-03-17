import SwiftUI

class ImageCanvasElementViewModel: ObservableObject {
    @Published var imageCanvasElement: ImageCanvasElement

    init(imageCanvasElement: ImageCanvasElement) {
        self.imageCanvasElement = imageCanvasElement
    }
}
