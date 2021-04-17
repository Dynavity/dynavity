import CoreGraphics

protocol CanvasElementDTOProtocol: Codable {
    var canvasProperties: CanvasElementPropertiesDTO { get }
}
