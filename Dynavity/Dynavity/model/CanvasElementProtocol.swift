import Foundation
import CoreGraphics

protocol CanvasElementProtocol {
    var id: UUID { get set }
    var position: CGPoint { get set }
    var visualID: String { get }
}
