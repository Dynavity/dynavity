import CoreGraphics

struct PDFElementDTO: CanvasElementProtocolDTO, Mappable {
    typealias Model = PDFElement

    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double

    let pdfDocumentDTO: PDFDocumentDTO

    func toModel() -> PDFElement {
        let model = PDFElement(position: position, pdfDocument: pdfDocumentDTO.toModel())
        model.width = width
        model.height = height
        model.rotation = rotation
        return model
    }
}
