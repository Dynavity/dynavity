import CoreGraphics
import Foundation

struct BacklinkNode: Identifiable {
    let id: UUID
    let name: String
    var position: CGPoint

    init(id: UUID, name: String, position: CGPoint) {
        self.id = id
        self.name = name
        self.position = position
    }

    init(name: String, position: CGPoint) {
        self.init(id: UUID(), name: name, position: position)
    }

    func moving(to updatedPos: CGPoint) -> BacklinkNode {
        BacklinkNode(name: self.name, position: updatedPos)
    }
}

extension BacklinkNode: Hashable {
    // Equality based solely on id
    static func == (lhs: BacklinkNode, rhs: BacklinkNode) -> Bool {
        lhs.id == rhs.id
    }

    // TODO: check if there's a better way of doing this since this can cause issues with
    // adjacency list implementation of graph
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension BacklinkNode: Codable {}
