import PDFKit

struct PDFDocumentDTO: Mappable {
    typealias Model = PDFDocument

    let pdfData: Data

    func toModel() -> PDFDocument {
        guard let pdf = PDFDocument(data: pdfData) else {
            fatalError("failed to decode PDF data")
        }
        return pdf
    }
}

extension PDFDocumentDTO: Codable {}
