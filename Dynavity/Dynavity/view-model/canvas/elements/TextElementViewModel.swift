import Foundation

class TextElementViewModel: ObservableObject {
    @Published var textBlock: TextElement

    init(textBlock: TextElement) {
        self.textBlock = textBlock
    }
}
