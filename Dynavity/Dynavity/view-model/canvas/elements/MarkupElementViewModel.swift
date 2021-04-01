import SwiftUI
import Combine

class MarkupElementViewModel: ObservableObject {
    private static let debounceDelay = 1.5

    @Published var markupElement: MarkupElement
    @Published var rawHtml: String = ""

    private let markupToHtmlExporter: MarkupToHtmlExporter = PandocMarkupToHtmlExporter()
    // Responsible for triggering a request to convert text to HTML when markupElement changes
    private var cancellationToken: AnyCancellable?
    // Responsible for retrieving the exported HTML from the HtmlExporter
    private var htmlCancellable: AnyCancellable?

    init(markupElement: MarkupElement) {
        self.markupElement = markupElement

        // Introduces a debounce so that we don't fetch the HTML that many times.
        // Implementation referenced from: https://stackoverflow.com/a/57365773
        cancellationToken = AnyCancellable($markupElement.removeDuplicates()
                                            .debounce(for: .seconds(MarkupElementViewModel.debounceDelay),
                                                      scheduler: RunLoop.main)
                                            .sink { _ in
                                                self.exportToHtml()
                                            }
        )
    }

    // Exported HTML will be assigned to `rawHtml` variable
    private func exportToHtml() {
        let htmlPublisher = self.markupToHtmlExporter.getHtmlPublisher(markupText: markupElement.text,
                                                                       markupType: markupElement.markupType)
        self.htmlCancellable = htmlPublisher
            .assign(to: \.rawHtml, on: self)
    }
}
