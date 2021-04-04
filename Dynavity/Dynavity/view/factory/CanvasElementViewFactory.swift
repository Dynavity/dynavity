import SwiftUI

class CanvasElementViewFactory: ViewFactory {
    private let umlElementFactory = UmlElementViewFactory()

    func createView(element: CanvasElementProtocol) -> some View {
        Group {
            switch element {
            case let imageElement as ImageElement:
                ImageElementView(imageElement: imageElement)
            case let pdfElement as PDFElement:
                PDFElementView(pdfElement: pdfElement)
            case let todoElement as TodoElement:
                TodoElementView(todoElement: todoElement)
            case let plainTextElement as PlainTextElement:
                PlainTextElementView(plainTextElement: plainTextElement)
            case let codeElement as CodeElement:
                CodeElementView(codeElement: codeElement)
            case let markupElement as MarkupElement:
                MarkupElementView(markupElement: markupElement)
            case let umlElement as UmlElementProtocol:
                umlElementFactory.createView(element: umlElement)
            default:
                fatalError("Unable to render unrecognized canvas element!")
            }
        }
    }
}
