import CoreGraphics

protocol TextElementProtocol: CanvasElementProtocol {
    var text: String { get set }
    /// TODO: once we've implemented the ability to change font sizes, update this to `set` as well
    var fontSize: CGFloat { get }
}

extension TextElementProtocol {
    var fontSize: CGFloat {
        14
    }
}
