struct BacklinkEdgeDTO: Mappable {
    typealias Model = BacklinkEdge

    let source: BacklinkNodeDTO
    let destination: BacklinkNodeDTO

    func toModel() -> BacklinkEdge {
        BacklinkEdge(source: source.toModel(), destination: destination.toModel())
    }
}

extension BacklinkEdgeDTO: Codable {}
