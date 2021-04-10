import PDFKit

struct PDFDocumentDTO: Mappable {
    let pdfData: Data

    init(model: PDFDocument) {
        self.pdfData = model.dataRepresentation() ?? Data()
    }

    func toModel() -> PDFDocument {
        guard let pdf = PDFDocument(data: pdfData) else {
            fatalError("failed to decode PDF data")
        }
        return pdf
    }
}

extension PDFDocumentDTO: Codable {}
