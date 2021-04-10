import Foundation

class PlainTextElementViewModel: ObservableObject {
    @Published var plainTextElement: PlainTextElement

    init(plainTextElement: PlainTextElement) {
        self.plainTextElement = plainTextElement
    }
}
