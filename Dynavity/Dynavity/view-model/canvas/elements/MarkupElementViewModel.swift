import SwiftUI
import Combine

class MarkupElementViewModel: ObservableObject {
    private static let debounceDelay = 1.5

    @Published var markupTextBlock: MarkupElement
    @Published var rawHtml: String = ""

    private let markupToHtmlExporter: HtmlExporter = MarkupToHtmlExporter()
    // Responsible for triggering a request to convert text to HTML when markUpTextBlock changes
    private var cancellationToken: AnyCancellable?
    // Responsible for retrieving the exported HTML from the HtmlExporter
    private var htmlCancellable: AnyCancellable?

    init(markupTextBlock: MarkupElement) {
        self.markupTextBlock = markupTextBlock

        // Introduces a debounce so that we don't fetch the HTML that many times.
        // Implementation referenced from: https://stackoverflow.com/a/57365773
        cancellationToken = AnyCancellable($markupTextBlock.removeDuplicates()
                                            .debounce(for: .seconds(MarkupElementViewModel.debounceDelay),
                                                      scheduler: RunLoop.main)
                                            .sink { _ in
                                                self.fetchHtml()
                                            }
        )
    }

    // Fetched HTML will be assigned to `rawHtml` variable
    private func fetchHtml() {
        let htmlPublisher = self.markupToHtmlExporter.getHtmlPublisher(markupText: markupTextBlock.text,
                                                                       markupType: markupTextBlock.markupType)
        self.htmlCancellable = htmlPublisher
            .assign(to: \.rawHtml, on: self)
    }
}
