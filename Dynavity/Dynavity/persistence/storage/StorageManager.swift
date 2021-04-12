protocol StorageManager {
    associatedtype ModelDTO

    func readAll() throws -> [ModelDTO]
    func save(model: ModelDTO) throws
    func delete(model: ModelDTO) throws

    func readBacklinkEngine() throws -> BacklinkEngineDTO?
    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws
}
