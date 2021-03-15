import Ink

struct MarkupTextBlock {
    private enum MarkupType {
        case markdown
    }

    private let parser = MarkdownParser()
    private let markupType: MarkupType = .markdown

    var rawText: String = ""
}

extension MarkupTextBlock: HtmlRenderable {
    func toHtml() -> String {
        switch markupType {
        case .markdown:
            return parser.html(from: rawText)
        }
    }
}
