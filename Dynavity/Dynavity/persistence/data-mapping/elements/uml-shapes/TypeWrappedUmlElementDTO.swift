import Foundation

enum TypeWrappedUmlElementDTO: Mappable {
    case umlActivity(ActivityUmlElementDTO)

    enum ElementType: String {
        case umlActivity
    }

    var type: ElementType {
        switch self {
        case .umlActivity:
            return .umlActivity
        }
    }

    var data: UmlElementProtocolDTO {
        switch self {
        case .umlActivity(let data):
            return data
        }
    }

    var model: IdentifiedUmlElementWrapper {
        switch self {
        case .umlActivity(let data):
            return data.toModel()
        }
    }

    init(model element: IdentifiedUmlElementWrapper) {
        switch element.umlElement {
        case is ActivityUmlElement:
            self = .umlActivity(ActivityUmlElementDTO(model: element))
        default:
            fatalError("Unknown type")
        }
    }

    func toModel() -> IdentifiedUmlElementWrapper {
        self.model
    }
}

extension TypeWrappedUmlElementDTO: Codable {
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
        case .umlActivity:
            self = .umlActivity(try decodeData(ActivityUmlElementDTO.self))
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
        case .umlActivity(let data):
            try encodeData(data)
        }
        try container.encode(type.rawValue, forKey: .type)
    }
}
