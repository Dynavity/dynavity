protocol OnlineStorageManagerProtocol: StorageManagerProtocol where ModelDTO == OnlineCanvasDTO {
    func importCanvas(ownerId: String, canvasName: String) throws -> OnlineCanvasDTO?
    func addChangeListeners(model: OnlineCanvas)
}
