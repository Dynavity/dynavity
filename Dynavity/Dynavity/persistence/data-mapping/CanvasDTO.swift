struct CanvasDTO: Mappable {
    typealias T = Canvas

    let canvasElements: [CanvasElementProtocolDTO]
    // TODO: add umlconnectors
    let name: String

    func toModel() -> Canvas {
        let canvasElementFactory = CanvasElementFactory()

        let model = Canvas()
        model.name = name
        for ele in canvasElements {
            model.addElement(canvasElementFactory.createDTO(element: ele))
        }
        return model
    }

}

// TODO: find a better way or hide this somewhere else
private class CanvasElementFactory {
    func createDTO(element: CanvasElementProtocolDTO) -> CanvasElementProtocol {
        switch element {
        case let imageElement as ImageElementDTO:
            return imageElement.toModel()
        case let pdfElement as PDFElementDTO:
            return pdfElement.toModel()
        case let todoElement as TodoElementDTO:
            return todoElement.toModel()
        case let codeElement as CodeElementDTO:
            return codeElement.toModel()
        case let markupElement as MarkupElementDTO:
            return markupElement.toModel()
        case let plainTextElement as PlainTextElementDTO:
            return plainTextElement.toModel()
        // TODO: complete this
//        case let umlElement as UmlElementProtocolDTO:
//            return umlElement.toModel()
        default:
            fatalError("Unable to convert unrecognised DTO!")
        }
    }
}
