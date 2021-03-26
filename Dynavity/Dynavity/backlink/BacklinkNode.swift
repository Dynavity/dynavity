import CoreGraphics
import Foundation

struct BacklinkNode: Identifiable {
    let id: UUID
    let name: String
    let position: CGPoint
}

extension BacklinkNode: Hashable {
    // Equality based solely on id
    static func == (lhs: BacklinkNode, rhs: BacklinkNode) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension BacklinkNode: Codable {}
