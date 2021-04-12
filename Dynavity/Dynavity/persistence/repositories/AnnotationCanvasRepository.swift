import Foundation

struct AnnotationCanvasRepository: Repository {
    typealias T = IdentifiedAnnotationCanvas

    let storageManager: StorageManager = LocalStorageManager()

    func queryAll() -> [IdentifiedAnnotationCanvas] {
        let annotationCanvasDTOs = (try? storageManager.readAllAnnotationCanvases()) ?? []
        return annotationCanvasDTOs.map({ $0.toModel() })
            .sorted(by: { $0.canvasName.lowercased() < $1.canvasName.lowercased() })
    }

    /// Returns true if the annotations was successfully saved. False otherwise.
    @discardableResult
    func save(model: IdentifiedAnnotationCanvas) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let annotationCanvasDTO = AnnotationCanvasDTO(id: id, model: model)
        do {
            try storageManager.saveAnnotationCanvas(annotationCanvas: annotationCanvasDTO)
            return true
        } catch {
            return false
        }

    }

    func update(oldModel: IdentifiedAnnotationCanvas, newModel: IdentifiedAnnotationCanvas) -> Bool {
        let id = getExistingId(for: oldModel) ?? UUID()
        do {
            let newAnnotationCanvasDTO = AnnotationCanvasDTO(id: id, model: newModel)
            try storageManager.saveAnnotationCanvas(annotationCanvas: newAnnotationCanvasDTO)
            return true
        } catch {
            return false
        }
    }

    @discardableResult
    func delete(model: IdentifiedAnnotationCanvas) -> Bool {
        let id = getExistingId(for: model) ?? UUID()
        let annotaionCanvasDTO = AnnotationCanvasDTO(id: id, model: model)
        do {
            try storageManager.deleteAnnotationCanvas(annotationCanvas: annotaionCanvasDTO)
            return true
        } catch {
            return false
        }
    }

    private func getExistingId(for annotation: IdentifiedAnnotationCanvas) -> UUID? {
        try? storageManager.readAllAnnotationCanvases()
            .first(where: { $0.name == annotation.canvasName })?.id
    }
}

// MARK: Unimplemented functions
extension AnnotationCanvasRepository {
    func deleteMany(models: [IdentifiedAnnotationCanvas]) -> Bool {
        // Current use cases of Dynavity does not require deleting all annotation canvases stored
        fatalError("Implementation not provided")
    }
}
