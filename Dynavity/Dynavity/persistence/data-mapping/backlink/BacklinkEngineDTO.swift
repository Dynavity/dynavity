struct BacklinkEngineDTO: Mappable {
    typealias T = BacklinkEngine

    fileprivate let backlinkNodes: [BacklinkNodeDTO]
    fileprivate let backlinkEdges: [BacklinkEdgeDTO]

    func toModel() -> BacklinkEngine {
        var engine = BacklinkEngine()

        for nodeDTO in backlinkNodes {
            let node = nodeDTO.toModel()
            engine.addNode(id: node.id, name: node.name)
        }
        for edgeDTO in backlinkEdges {
            let edge = edgeDTO.toModel()
            engine.addLinkBetween(edge.source.id, and: edge.destination.id)
        }

        return engine
    }
}

extension BacklinkEngineDTO: Codable {}
