protocol StorageManagerProtocol {
    associatedtype ModelDTO

    func readAll() throws -> [ModelDTO]
    func save(model: ModelDTO) throws
    func delete(model: ModelDTO) throws
}

protocol OfflineStorageManagerProtocol: StorageManagerProtocol where ModelDTO == CanvasDTO {
    func readBacklinkEngine() throws -> BacklinkEngineDTO?
    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws
}

protocol OnlineStorageManagerProtocol: StorageManagerProtocol where ModelDTO == OnlineCanvasDTO {
    func importCanvas(ownerId: String, canvasName: String) throws -> OnlineCanvasDTO?
    func addChangeListeners(model: OnlineCanvas)
}
