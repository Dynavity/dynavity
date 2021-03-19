import SwiftUI
import Combine

class MarkupTextBlockViewModel: ObservableObject, HtmlRenderable {
    private static let debounceDelay = 1.5

    @Published var markupTextBlock: MarkupTextBlock
    @Published var rawHtml: String = ""

    // Responsible for triggering a request to external API when markUpTextBlock changes
    private var cancellationToken: AnyCancellable?
    // Responsible for retrieving data from external API
    private var requestCancellable: AnyCancellable?

    init(markupTextBlock: MarkupTextBlock) {
        self.markupTextBlock = markupTextBlock

        // Introduces a debounce so that we don't send too many requests out.
        // Implementation referenced from: https://stackoverflow.com/a/57365773
        cancellationToken = AnyCancellable($markupTextBlock.removeDuplicates()
                                            .debounce(for: .seconds(MarkupTextBlockViewModel.debounceDelay),
                                                      scheduler: RunLoop.main)
                                            .sink { textBlock in
                                                self.convertTextToHtml(text: textBlock.text,
                                                                       inputFormat: textBlock.markupType)
                                            }
        )
    }

    private func convertTextToHtml(text: String, inputFormat: MarkupTextBlock.MarkupType) {
        let stringEncoding: String.Encoding = .utf8
        let request = constructURLRequest(with: text.data(using: stringEncoding))

        requestCancellable = URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            let httpResponse = response as? HTTPURLResponse

            guard httpResponse?.statusCode != 400,
                  let rawHtml = String(bytes: data, encoding: stringEncoding) else {
                return "Error: Invalid / unsupported syntax used."
            }

            return rawHtml
        }
        // Only source of failure is due to invalid URL, which should have been validated
        .assertNoFailure()
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        .assign(to: \.rawHtml, on: self)
    }

    /// Constructs a POST request to https://pandoc.bilimedtech.com/ that seeks to convert
    /// the current input format into html.
    /// - Parameter data: The data that is to be sent in the body of the request (e.g. the raw text)
    private func constructURLRequest(with data: Data?) -> URLRequest {
        let inputFormat = markupTextBlock.markupType.rawValue
        let outputFormat = "html"

        guard let url = URL(string: "https://pandoc.bilimedtech.com/\(outputFormat)") else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/\(inputFormat)", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return request
    }
}
