struct CanvasRepository: Repository {
    typealias T = Canvas

    let storageManager: StorageManager = LocalStorageManager()

    func queryAll() -> [Canvas] {
        let canvasDTOs = (try? storageManager.readAllCanvases()) ?? []
        return canvasDTOs.map({ $0.toModel() })
    }

    /// Returns true if the canvas was successfully saved. False otherwise.
    func save(model: Canvas) -> Bool {
        let canvasDTO = CanvasDTO(model: model)
        do {
            try storageManager.saveCanvas(canvas: canvasDTO)
            return true
        } catch {
            return false
        }
    }
}
