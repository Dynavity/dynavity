import Foundation
import CoreGraphics

protocol CanvasElementProtocol {
    var id: UUID { get }
    var position: CGPoint { get set }
    var width: CGFloat { get set }
    var height: CGFloat { get set }
}
