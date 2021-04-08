import CoreGraphics

protocol CanvasElementProtocolDTO: Codable {
    var position: CGPoint { get }
    var width: CGFloat { get }
    var height: CGFloat { get }
    var rotation: Double { get }
}
