import CoreGraphics
import Foundation

struct BacklinkNodeDTO: Mappable {
    typealias Model = BacklinkNode

    let id: UUID
    let name: String
    let position: CGPoint

    init(model: BacklinkNode) {
        self.id = model.id
        self.name = model.name
        self.position = model.position
    }

    func toModel() -> BacklinkNode {
        BacklinkNode(id: id, name: name, position: position)
    }
}

extension BacklinkNodeDTO: Codable {}
