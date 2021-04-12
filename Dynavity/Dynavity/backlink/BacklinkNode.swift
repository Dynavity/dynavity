import CoreGraphics
import Foundation

struct BacklinkNode {
    var name: String
    var position: CGPoint

    init(name: String, position: CGPoint) {
        self.name = name
        self.position = position
    }

    func renaming(to newName: String) -> BacklinkNode {
        BacklinkNode(name: newName, position: self.position)
    }

    func moving(to updatedPos: CGPoint) -> BacklinkNode {
        BacklinkNode(name: self.name, position: updatedPos)
    }
}

extension BacklinkNode: Hashable {
    // Equality based solely on name
    static func == (lhs: BacklinkNode, rhs: BacklinkNode) -> Bool {
        lhs.name == rhs.name
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name)
    }
}
