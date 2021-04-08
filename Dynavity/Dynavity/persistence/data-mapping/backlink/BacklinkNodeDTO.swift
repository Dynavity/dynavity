import CoreGraphics
import Foundation

struct BacklinkNodeDTO: Mappable {
    typealias T = BacklinkNode

    let id: UUID
    let name: String
    let position: CGPoint

    func toModel() -> BacklinkNode {
        BacklinkNode(id: id, name: name, position: position)
    }
}

extension BacklinkNodeDTO: Codable {}
