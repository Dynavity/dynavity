struct BacklinkEngineDTO: Mappable {
    fileprivate let backlinkNodes: [BacklinkNodeDTO]
    fileprivate let backlinkEdges: [BacklinkEdgeDTO]

    init(model: BacklinkEngine) {
        self.backlinkNodes = model.nodes.map({ BacklinkNodeDTO(model: $0) })
        self.backlinkEdges = model.edges.map({ BacklinkEdgeDTO(model: $0) })
    }

    func toModel() -> BacklinkEngine {
        var engine = BacklinkEngine()

        for nodeDTO in backlinkNodes {
            let node = nodeDTO.toModel()
            engine.addNode(node: node)
        }
        for edgeDTO in backlinkEdges {
            let edge = edgeDTO.toModel()
            engine.addEdge(edge: edge)
        }

        return engine
    }
}

extension BacklinkEngineDTO: Codable {}
