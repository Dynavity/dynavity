protocol StorageManagerProtocol {
    associatedtype ModelDTO

    func readAll() throws -> [ModelDTO]
    func save(model: ModelDTO) throws
    func delete(model: ModelDTO) throws
}
