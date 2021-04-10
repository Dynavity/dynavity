import SwiftUI

struct UIImageDTO: Mappable {
    let pngData: Data

    init(model: UIImage) {
        self.pngData = model.pngData() ?? Data()
    }

    func toModel() -> UIImage {
        guard let image = UIImage(data: pngData) else {
            fatalError("failed to decode PNG data")
        }
        return image
    }
}

extension UIImageDTO: Codable {}
