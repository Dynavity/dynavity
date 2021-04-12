protocol StorageManager {
<<<<<<< HEAD
    func readAllCanvases() throws -> [CanvasDTO]
    func saveCanvas(canvas: CanvasDTO) throws
    func deleteCanvas(canvas: CanvasDTO) throws

    func readBacklinkEngine() throws -> BacklinkEngineDTO?
    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws
=======
    associatedtype ModelDTO

    func readAll() throws -> [ModelDTO]
    func save(model: ModelDTO) throws
    func delete(model: ModelDTO) throws
>>>>>>> Set up CloudStorageManager
}
