protocol OfflineStorageManagerProtocol: StorageManagerProtocol where ModelDTO == CanvasDTO {
    func readBacklinkEngine() throws -> BacklinkEngineDTO?
    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws
}
