import Foundation

struct CanvasDTO: Mappable {
    var id: UUID
    let canvasElements: [TypeWrappedCanvasElementDTO]
    let umlConnectors: [UmlConnectorDTO]
    let name: String

    init(id: UUID, model: Canvas) {
        self.id = id
        self.name = model.name
        self.canvasElements = model.canvasElements.map({ TypeWrappedCanvasElementDTO(model: $0) })
        self.umlConnectors = model.umlConnectors.map({ UmlConnectorDTO(model: $0) })
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
        for connector in umlConnectors {
            model.addUmlConnector(connector.toModel())
        }
        return model
    }
}

extension CanvasDTO: Codable {}
