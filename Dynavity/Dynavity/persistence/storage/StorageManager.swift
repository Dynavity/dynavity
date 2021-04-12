protocol StorageManager {
    func readAllCanvases() throws -> [CanvasDTO]
    func saveCanvas(canvas: CanvasDTO) throws
    func deleteCanvas(canvas: CanvasDTO) throws

    func readBacklinkEngine() throws -> BacklinkEngineDTO?
    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws
}
