import Foundation

class TextBlockViewModel: ObservableObject {
    @Published var textBlock: TextBlock

    init(textBlock: TextBlock) {
        self.textBlock = textBlock
    }
}
