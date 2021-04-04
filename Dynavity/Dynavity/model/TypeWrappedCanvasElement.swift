import Foundation

enum TypeWrappedCanvasElement: Codable {
    case image(ImageElement)
    case pdf(PDFElement)
    case todo(TodoElement)
    case text(PlainTextElement)
    case code(CodeElement)
    case markup(MarkupElement)
    case umlDiamond(DiamondUmlElement)
    case umlRectangle(RectangleUmlElement)

    enum ElementType: String {
        case image
        case pdf
        case todo
        case text
        case code
        case markup
        case umlDiamond
        case umlRectangle
    }

    var type: ElementType {
        switch self {
        case .image:
            return .image
        case .pdf:
            return .pdf
        case .todo:
            return .todo
        case .text:
            return .text
        case .code:
            return .code
        case .markup:
            return .markup
        case .umlDiamond:
            return .umlDiamond
        case .umlRectangle:
            return .umlRectangle
        }
    }

    var data: CanvasElementProtocol {
        switch self {
        case .image(let data):
            return data
        case .pdf(let data):
            return data
        case .todo(let data):
            return data
        case .text(let data):
            return data
        case .code(let data):
            return data
        case .markup(let data):
            return data
        case .umlDiamond(let data):
            return data
        case .umlRectangle(let data):
            return data
        }
    }

    init(element: CanvasElementProtocol) {
        switch element {
        case let imageElement as ImageElement:
            self = .image(imageElement)
        case let pdfElement as PDFElement:
            self = .pdf(pdfElement)
        case let todoElement as TodoElement:
            self = .todo(todoElement)
        case let plainTextElement as PlainTextElement:
            self = .text(plainTextElement)
        case let codeElement as CodeElement:
            self = .code(codeElement)
        case let markupElement as MarkupElement:
            self = .markup(markupElement)
        case let diamondUmlElement as DiamondUmlElement:
            self = .umlDiamond(diamondUmlElement)
        case let rectangleUmlElement as RectangleUmlElement:
            self = .umlRectangle(rectangleUmlElement)
        default:
            fatalError("Unknown type")
        }
    }

    private enum CodingKeys: String, CodingKey {
        case type, data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let typeRaw = try container.decode(String.self, forKey: .type)
        let type = ElementType(rawValue: typeRaw)
        func decodeData<T: Decodable>(_ type: T.Type) throws -> T {
            try container.decode(type, forKey: .data)
        }
        switch type {
        case .image:
            self = .image(try decodeData(ImageElement.self))
        case .pdf:
            self = .pdf(try decodeData(PDFElement.self))
        case .todo:
            self = .todo(try decodeData(TodoElement.self))
        case .text:
            self = .text(try decodeData(PlainTextElement.self))
        case .code:
            self = .code(try decodeData(CodeElement.self))
        case .markup:
            self = .markup(try decodeData(MarkupElement.self))
        case .umlDiamond:
            self = .umlDiamond(try decodeData(DiamondUmlElement.self))
        case .umlRectangle:
            self = .umlRectangle(try decodeData(RectangleUmlElement.self))
        case .none:
            fatalError("Unknown type")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        func encodeData<T: Encodable>(_ data: T) throws {
            try container.encode(data, forKey: .data)
        }
        switch self {
        case .image(let data):
            try encodeData(data)
        case .pdf(let data):
            try encodeData(data)
        case .todo(let data):
            try encodeData(data)
        case .text(let data):
            try encodeData(data)
        case .code(let data):
            try encodeData(data)
        case .markup(let data):
            try encodeData(data)
        case .umlDiamond(let data):
            try encodeData(data)
        case .umlRectangle(let data):
            try encodeData(data)
        }
        try container.encode(type.rawValue, forKey: .type)
    }
}
