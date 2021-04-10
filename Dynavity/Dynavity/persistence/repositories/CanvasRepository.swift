import Foundation

struct CanvasRepository: Repository {
    typealias T = Canvas

    let storageManager: StorageManager = LocalStorageManager()

    /// Canvases are sorted in ascending order based on their names (case-insensitive)
    func queryAll() -> [Canvas] {
        let canvasDTOs = (try? storageManager.readAllCanvases()) ?? []
        return canvasDTOs.map({ $0.toModel() })
            .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }

    /// Returns true if the canvas was successfully saved. False otherwise.
    @discardableResult
    func save(model: Canvas) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let canvasDTO = CanvasDTO(id: id, model: model)
        do {
            try storageManager.saveCanvas(canvas: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func update(oldModel: Canvas, newModel: Canvas) -> Bool {
        let id = getExistingId(for: oldModel) ?? UUID()
        do {
            let newCanvasDTO = CanvasDTO(id: id, model: newModel)
            try storageManager.saveCanvas(canvas: newCanvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func delete(model: Canvas) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let canvasDTO = CanvasDTO(id: id, model: model)
        do {
            try storageManager.deleteCanvas(canvas: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    /// Note: this is not an atomic operation
    @discardableResult
    func deleteMany(models: [Canvas]) -> Bool {
        let canvasDTOs = models.map({ delete(model: $0) })
        // Returns true if and only if all the canvases were successfully deleted
        return canvasDTOs.allSatisfy({ $0 })
    }

    private func getExistingId(for canvas: Canvas) -> UUID? {
        try? storageManager.readAllCanvases()
            .first(where: { $0.name == canvas.name })?.id
    }
}
