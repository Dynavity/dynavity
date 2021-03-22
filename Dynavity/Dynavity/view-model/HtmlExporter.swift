import Combine

protocol HtmlExporter {
    func getHtmlPublisher(markupText: String, markupType: MarkupElement.MarkupType) -> AnyPublisher<String, Never>
}
