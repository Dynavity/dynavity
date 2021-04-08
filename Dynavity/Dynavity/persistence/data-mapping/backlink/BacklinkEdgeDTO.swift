struct BacklinkEdgeDTO: Mappable {
    typealias T = BacklinkEdge

    let source: BacklinkNodeDTO
    let destination: BacklinkNodeDTO

    func toModel() -> BacklinkEdge {
        BacklinkEdge(source: source.toModel(), destination: destination.toModel())
    }
}

extension BacklinkEdgeDTO: Codable {}
