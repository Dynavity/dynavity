struct CanvasDTO: Mappable {
    let canvasElements: [TypeWrappedCanvasElementDTO]
    // TODO: add umlconnectors
    let name: String

    init(model: Canvas) {
        self.name = model.name
        self.canvasElements = model.canvasElements.map({ TypeWrappedCanvasElementDTO(model: $0) })
    }

    func toModel() -> Canvas {
        let model = Canvas()
        model.name = name
        for ele in canvasElements {
            model.addElement(ele.toModel())
        }
        return model
    }
}

extension CanvasDTO: Codable {}
