import CoreGraphics

struct PDFElementDTO: CanvasElementProtocolDTO, Mappable {
    let canvasProperties: CanvasElementPropertiesDTO

    let pdfDocumentDTO: PDFDocumentDTO

    init(model: PDFElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.pdfDocumentDTO = PDFDocumentDTO(model: model.pdfDocument)
    }

    func toModel() -> PDFElement {
        let model = PDFElement(position: canvasProperties.position, pdfDocument: pdfDocumentDTO.toModel())
        model.canvasProperties = canvasProperties.toModel()
        return model
    }
}
