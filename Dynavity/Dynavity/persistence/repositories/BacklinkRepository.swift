// Certain functions are not implemented as there's no use case for them in our application at the moment
struct BacklinkRepository: Repository {
    let storageManager = LocalStorageManager()

    func queryAll() -> [BacklinkEngine] {
        [try? storageManager.readBacklinkEngine()].compactMap({ $0?.toModel() })
    }

    @discardableResult
    func save(model: BacklinkEngine) -> Bool {
        let dto = BacklinkEngineDTO(model: model)
        do {
            try storageManager.saveBacklinkEngine(backlinkEngine: dto)
            return true
        } catch {
            return false
        }
    }

    func update(oldModel: BacklinkEngine, newModel: BacklinkEngine) -> Bool {
        fatalError("Not yet implemented")
    }

    func delete(model: BacklinkEngine) -> Bool {
        fatalError("Not yet implemented")
    }

    func deleteMany(models: [BacklinkEngine]) -> Bool {
        fatalError("Not yet implemented")
    }
}
