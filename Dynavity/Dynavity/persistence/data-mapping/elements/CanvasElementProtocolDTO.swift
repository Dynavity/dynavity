import CoreGraphics

protocol CanvasElementProtocolDTO: Codable {
    var canvasProperties: CanvasElementPropertiesDTO { get }
}
