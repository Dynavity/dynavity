import Foundation

struct CanvasRepository: Repository {

    let storageManager = LocalStorageManager()

    /// Canvases are sorted in ascending order based on their names (case-insensitive)
    func queryAll() -> [CanvasWithAnnotation] {
        let canvasDTOs = (try? storageManager.readAll()) ?? []
        return canvasDTOs.map({ $0.toModel() })
            .sorted(by: { $0.name.lowercased() < $1.name.lowercased() })
    }

    /// Returns true if the canvas was successfully saved. False otherwise.
    @discardableResult
    func save(model: CanvasWithAnnotation) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let canvasDTO = CanvasDTO(id: id, model: model)
        do {
            try storageManager.save(model: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func update(oldModel: CanvasWithAnnotation, newModel: CanvasWithAnnotation) -> Bool {
        let id = getExistingId(for: oldModel) ?? UUID()
        do {
            let newCanvasDTO = CanvasDTO(id: id, model: newModel)
            try storageManager.save(model: newCanvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func delete(model: CanvasWithAnnotation) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let canvasDTO = CanvasDTO(id: id, model: model)
        do {
            try storageManager.delete(model: canvasDTO)
            return true
        } catch {
            return false
        }
    }

    /// Note: this is not an atomic operation
    @discardableResult
    func deleteMany(models: [CanvasWithAnnotation]) -> Bool {
        let canvasDTOs = models.map({ delete(model: $0) })
        // Returns true if and only if all the canvases were successfully deleted
        return canvasDTOs.allSatisfy({ $0 })
    }

    private func getExistingId(for canvas: CanvasWithAnnotation) -> UUID? {
        try? storageManager.readAllCanvases()
            .first(where: { $0.name == canvas.name })?.id
    }
}
