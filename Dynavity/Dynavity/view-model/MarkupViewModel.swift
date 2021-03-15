import SwiftUI
import Combine

class MarkupViewModel: ObservableObject, HtmlRenderable {
    @Published var markupTextBlock = MarkupTextBlock() {
        didSet {
            // TODO: possibly implement some debouncing
            convertTextToHtml()
        }
    }
    @Published var rawHtml: String = ""

    private var cancellationToken: AnyCancellable?

    private func convertTextToHtml() {
        let text = markupTextBlock.text
        let inputFormat = markupTextBlock.markupType.rawValue
        let outputFormat = "html"

        guard let url = URL(string: "https://pandoc.bilimedtech.com/\(outputFormat)") else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/\(inputFormat)", forHTTPHeaderField: "Content-Type")

        let stringEncoding: String.Encoding = .utf8
        request.httpBody = text.data(using: stringEncoding)

        cancellationToken = URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            let httpResponse = response as? HTTPURLResponse

            guard httpResponse?.statusCode != 400,
                  let rawHtml = String(bytes: data, encoding: stringEncoding) else {
                // Handle bad responses by returning whatever valid html we previously had
                return self.rawHtml
            }

            return rawHtml
        }
        .assertNoFailure() // only source of failure is due to invalid URL, which should have been validated
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        .assign(to: \.rawHtml, on: self)
    }
}
