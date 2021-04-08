struct CanvasDTO: Mappable {
    typealias T = Canvas

    let canvasElements: [TypeWrappedCanvasElementDTO]
    // TODO: add umlconnectors
    let name: String

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
