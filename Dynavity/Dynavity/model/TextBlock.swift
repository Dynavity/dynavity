import CoreGraphics

protocol TextBlock: CanvasElementProtocol {
    var text: String { get set }
    var fontSize: CGFloat { get set }
}
