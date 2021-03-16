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

        guard markupTextBlock.markupType != .plaintext else {
            rawHtml = text
            return
        }

        let stringEncoding: String.Encoding = .utf8
        let request = constructURLRequest(with: text.data(using: stringEncoding))

        cancellationToken = URLSession.shared.dataTaskPublisher(for: request).tryMap { data, response in
            let httpResponse = response as? HTTPURLResponse

            guard httpResponse?.statusCode != 400,
                  let rawHtml = String(bytes: data, encoding: stringEncoding) else {
                return "Error: Invalid / unsupported syntax used."
            }

            return rawHtml
        }
        .assertNoFailure() // only source of failure is due to invalid URL, which should have been validated
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
        .assign(to: \.rawHtml, on: self)
    }

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
