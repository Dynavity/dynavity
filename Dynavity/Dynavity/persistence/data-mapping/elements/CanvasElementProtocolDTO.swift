import CoreGraphics

protocol CanvasElementProtocolDTO {
    var position: CGPoint { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    var rotation: Double { get }
}
