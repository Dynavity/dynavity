import Foundation

struct CanvasRepository: Repository {

    let localStorageManager = LocalStorageManager()
    let cloudStorageManager = CloudStorageManager()

    /// Canvases are sorted in ascending order based on their names (case-insensitive)
    func queryAll() -> [Canvas] {
        let localCanvasDTOs = (try? localStorageManager.readAll()) ?? []
        let localCanvases = localCanvasDTOs.map { $0.toModel() }
        let cloudCanvasDTOs = (try? cloudStorageManager.readAll()) ?? []
        let cloudCanvases = cloudCanvasDTOs.map { $0.toModel() }
        return (localCanvases + cloudCanvases)
            .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }

    /// Returns true if the canvas was successfully saved. False otherwise.
    @discardableResult
    func save(model: Canvas) -> Bool {
        if let onlineCanvas = model as? OnlineCanvas {
            return saveCloud(model: onlineCanvas)
        } else {
            return saveLocal(model: model)
        }
    }

    private func saveLocal(model: Canvas) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let canvasDTO = CanvasDTO(id: id, model: model)
        do {
            try localStorageManager.save(model: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    private func saveCloud(model: OnlineCanvas) -> Bool {
        do {
            try cloudStorageManager.save(model: OnlineCanvasDTO(model: model))
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func update(oldModel: Canvas, newModel: Canvas) -> Bool {
        delete(model: oldModel) && save(model: newModel)
    }

    @discardableResult
    func delete(model: Canvas) -> Bool {
        if let onlineCanvas = model as? OnlineCanvas {
            return deleteCloud(model: onlineCanvas)
        } else {
            return deleteLocal(model: model)
        }
    }

    private func deleteLocal(model: Canvas) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let canvasDTO = CanvasDTO(id: id, model: model)
        do {
            try localStorageManager.delete(model: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    private func deleteCloud(model: OnlineCanvas) -> Bool {
        do {
            try cloudStorageManager.delete(model: OnlineCanvasDTO(model: model))
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
        try? localStorageManager.readAll()
            .first(where: { $0.name == canvas.name })?.id
    }
}
