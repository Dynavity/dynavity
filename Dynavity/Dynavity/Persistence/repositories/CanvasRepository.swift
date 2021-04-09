struct CanvasRepository: Repository {
    typealias T = Canvas

    let storageManager: StorageManager = LocalStorageManager()

    func queryAll() -> [Canvas] {
        let canvasDTOs = (try? storageManager.readAllCanvases()) ?? []
        return canvasDTOs.map({ $0.toModel() })
    }

    /// Returns true if the canvas was successfully saved. False otherwise.
    @discardableResult
    func save(model: Canvas) -> Bool {
        let canvasDTO = CanvasDTO(model: model)
        do {
            try storageManager.saveCanvas(canvas: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func delete(model: Canvas) -> Bool {
        let canvasDTO = CanvasDTO(model: model)
        do {
            try storageManager.deleteCanvas(canvas: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func deleteMany(models: [Canvas]) -> Bool {
        let canvasDTOs = models.map({ delete(model: $0) })
        // Returns true if and only if all the canvases were successfully deleted
        return canvasDTOs.allSatisfy({ $0 })

    }
}
