protocol UmlElementProtocolDTO: CanvasElementDTOProtocol {
    var label: String { get set }
    var umlType: String { get }
    var umlShape: String { get }
    var id: UmlElementId { get }
}
