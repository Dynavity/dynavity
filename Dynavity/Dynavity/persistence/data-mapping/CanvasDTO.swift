import Foundation

struct CanvasDTO: Mappable {
    var id: UUID
    let canvasElements: [TypeWrappedCanvasElementDTO]
    let umlConnectors: [UmlConnectorDTO]
    let name: String

    init(id: UUID, model: Canvas) {
        self.id = id
        self.name = model.name
        let canvasElementDTOs = model.canvasElements.map({ TypeWrappedCanvasElementDTO(model: $0) })
        self.canvasElements = canvasElementDTOs
        self.umlConnectors = model.umlConnectors.map({ UmlConnectorDTO(model: $0,
                                                                       canvasElementDTOs: canvasElementDTOs,
                                                                       canvasElements: model.canvasElements) })
    }

    init(model: Canvas) {
        self.init(id: UUID(), model: model)
    }

    func toModel() -> Canvas {
        let model = Canvas()
        model.name = name
        for ele in canvasElements {
            model.addElement(ele.toModel())
        }
        for uml in umlConnectors {
            model.addUmlConnector(uml.toModel(canvasElementDTOs: canvasElements,
                                              canvasElements: model.canvasElements))
        }
        return model
    }
}

extension CanvasDTO: Codable {}
