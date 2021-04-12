import CoreGraphics
import Foundation

struct BacklinkNode {
    let name: String
    var position: CGPoint

    init(name: String, position: CGPoint) {
        self.init(name: name, position: position)
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
