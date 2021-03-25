import SwiftUI

class CanvasElementViewFactory: ViewFactory {
    func createView(element: CanvasElementProtocol) -> some View {
        Group {
            switch element {
            case let imageCanvasElement as ImageElement:
                ImageElementView(imageCanvasElement: imageCanvasElement)
            case let pdfCanvasElement as PDFElement:
                PDFElementView(pdfCanvasElement: pdfCanvasElement)
            case let plainTextElement as PlainTextElement:
                PlainTextElementView(plainTextElement: plainTextElement)
            case let codeSnippet as CodeElement:
                CodeElementView(codeSnippet: codeSnippet)
            case let markupTextBlock as MarkupElement:
                MarkupElementView(markupTextBlock: markupTextBlock)
            default:
                TestElementView(element: element)
            }
        }
    }
}
