struct BacklinkEdgeDTO: Mappable {
    let source: BacklinkNodeDTO
    let destination: BacklinkNodeDTO

    init(model: BacklinkEdge) {
        self.source = BacklinkNodeDTO(model: model.source)
        self.destination = BacklinkNodeDTO(model: model.destination)
    }

    func toModel() -> BacklinkEdge {
        BacklinkEdge(source: source.toModel(), destination: destination.toModel())
    }
}

extension BacklinkEdgeDTO: Codable {}
