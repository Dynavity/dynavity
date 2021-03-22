import Combine

protocol MarkupToHtmlExporter {
    func getHtmlPublisher(markupText: String, markupType: MarkupElement.MarkupType) -> AnyPublisher<String, Never>
}
