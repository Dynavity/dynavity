import SwiftUI

/**
 Encapsulates a `UIImage` within  a `Codable` struct.
 */
struct CodableImage: Codable, Equatable {
    let image: UIImage

    init(image: UIImage) {
        self.image = image
    }

    private enum CodingKeys: String, CodingKey {
        case image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let data = try container.decode(Data.self, forKey: .image)
        guard let image = UIImage(data: data) else {
            fatalError("Error decoding image")
        }
        self.image = image
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        let data = image.pngData() ?? Data()
        try container.encode(data, forKey: .image)
    }
}
