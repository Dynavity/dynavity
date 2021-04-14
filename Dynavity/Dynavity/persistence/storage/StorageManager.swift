protocol StorageManager {
    associatedtype ModelDTO

    func readAll() throws -> [ModelDTO]
    func save(model: ModelDTO) throws
    func delete(model: ModelDTO) throws
}

protocol OfflineStorageManager: StorageManager where ModelDTO == CanvasDTO {
    func readBacklinkEngine() throws -> BacklinkEngineDTO?
    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws
}

protocol OnlineStorageManager: StorageManager where ModelDTO == OnlineCanvasDTO {
    func importCanvas(ownerId: String, canvasName: String) throws -> OnlineCanvasDTO?
}
