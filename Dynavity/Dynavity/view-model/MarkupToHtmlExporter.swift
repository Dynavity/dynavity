import Combine
import Foundation

struct MarkupToHtmlExporter: HtmlExporter {
    // Endpoint also allows specifying other output format using
    // "https://pandoc.bilimedtech.com/\(outputFormat)"
    // But we are only concerned with HTML output
    private static let endpoint = "https://pandoc.bilimedtech.com/html"

    func getHtmlPublisher(markupText: String, markupType: MarkupElement.MarkupType) -> AnyPublisher<String, Never> {
        let stringEncoding: String.Encoding = .utf8
        let request = constructURLRequest(with: markupText.data(using: stringEncoding), inputFormat: markupType)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response in
                let httpResponse = response as? HTTPURLResponse

                guard httpResponse?.statusCode != 400,
                      let rawHtml = String(bytes: data, encoding: stringEncoding) else {
                    return "Error: Invalid / unsupported syntax used."
                }

                return rawHtml
            }
            .assertNoFailure()
            .eraseToAnyPublisher()
    }

    /// Constructs a POST request to `endpoint` that seeks to convert the current input
    /// format into html.
    /// - Parameter data: The data that is to be sent in the body of the request (e.g. the raw text)
    private func constructURLRequest(with data: Data?, inputFormat: MarkupElement.MarkupType) -> URLRequest {
        guard let url = URL(string: MarkupToHtmlExporter.endpoint) else {
            fatalError("Invalid URL")
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("text/\(inputFormat)", forHTTPHeaderField: "Content-Type")
        request.httpBody = data

        return request
    }
}
