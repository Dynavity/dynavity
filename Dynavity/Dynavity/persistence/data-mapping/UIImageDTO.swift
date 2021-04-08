import SwiftUI

struct UIImageDTO: Mappable {
    typealias T = UIImage

    let pngData: Data

    func toModel() -> UIImage {
        guard let image = UIImage(data: pngData) else {
            fatalError("failed to decode PNG data")
        }
        return image
    }
}

extension UIImageDTO: Codable {}
