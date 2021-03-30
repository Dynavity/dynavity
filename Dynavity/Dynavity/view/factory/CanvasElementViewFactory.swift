import SwiftUI

class CanvasElementViewFactory: ViewFactory {
    func createView(element: CanvasElementProtocol) -> some View {
        Group {
            switch element {
            case let imageElement as ImageElement:
                ImageElementView(imageElement: imageElement)
            case let pdfElement as PDFElement:
                PDFElementView(pdfElement: pdfElement)
            case let plainTextElement as PlainTextElement:
                PlainTextElementView(plainTextElement: plainTextElement)
            case let codeElement as CodeElement:
                CodeElementView(codeElement: codeElement)
            case let markupElement as MarkupElement:
                MarkupElementView(markupElement: markupElement)
            default:
                TestElementView(element: element)
            }
        }
    }
}
