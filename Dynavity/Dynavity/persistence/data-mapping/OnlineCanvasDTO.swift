import Foundation

struct OnlineCanvasDTO: Mappable {
    static let myUserId = OnlineCanvas.myUserId

    let ownerId: String
    let canvas: CanvasDTO

    init(model: OnlineCanvas) {
        self.ownerId = model.ownerId
        self.canvas = CanvasDTO(model: model)
    }

    init(ownerId: String, canvas: CanvasDTO) {
        self.ownerId = ownerId
        self.canvas = canvas
    }

    func toModel() -> OnlineCanvas {
        let model = OnlineCanvas(ownerId: ownerId, canvas: canvas.toModel())
        CanvasRepository().addCloudChangeListeners(model: model)
        return model
    }
}
