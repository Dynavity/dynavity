import CoreGraphics

protocol UmlElementProtocolDTO: CanvasElementProtocolDTO {
    var label: String { get set }
    var umlType: String { get }
    var umlShape: String { get }
}
