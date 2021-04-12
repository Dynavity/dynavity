import CoreGraphics
import Foundation

struct BacklinkNodeDTO: Mappable {
    let name: String
    let position: CGPoint

    init(model: BacklinkNode) {
        self.name = model.name
        self.position = model.position
    }

    func toModel() -> BacklinkNode {
        BacklinkNode(name: name, position: position)
    }
}

extension BacklinkNodeDTO: Codable {}
