import SwiftUI

class CanvasSelectionViewModel: ObservableObject {
    private let canvasRepo = CanvasRepository()
    private let annotationCanvasRepo = AnnotationCanvasRepository()

    @Published var selectedCanvases: [Canvas] = []
    @Published var searchQuery: String = ""

    func getCanvases() -> [Canvas] {
        canvasRepo.queryAll()
    }

    func getFilteredCanvases() -> [Canvas] {
        getCanvases().filter {
            if searchQuery.isEmpty {
                return true
            }
            return $0.name.lowercased().contains(self.searchQuery.lowercased())
        }
    }

    func toggleSelectedCanvas(_ canvas: Canvas) {
        let wasCanvasSelected = isCanvasSelected(canvas)
        if wasCanvasSelected {
            selectedCanvases = selectedCanvases.filter({ $0 !== canvas })
        } else {
            selectedCanvases.append(canvas)
        }
    }

    func clearSelectedCanvases() {
        selectedCanvases = []
    }

    func deleteSelectedCanvases() {
        canvasRepo.deleteMany(models: selectedCanvases)
        self.objectWillChange.send()
    }

    func deleteCanvas(_ canvas: Canvas) {
        canvasRepo.delete(model: canvas)
        self.objectWillChange.send()
    }

    func createCanvas(name: String) {
        let canvas = Canvas()
        canvas.name = name
        canvasRepo.save(model: canvas)
        self.objectWillChange.send()
    }

    func renameCanvas(_ canvas: Canvas, updatedName: String) {
        let newCanvas = Canvas(canvas: canvas)
        newCanvas.name = updatedName
        canvasRepo.update(oldModel: canvas, newModel: newCanvas)
        self.objectWillChange.send()
    }

    func isValidCanvasName(name: String) -> Bool {
        !name.isEmpty && isCanvasNameUnique(name: name)
    }

    // Case-insensitive checking
    private func isCanvasNameUnique(name: String) -> Bool {
        !canvasRepo.queryAll().map({ $0.name.lowercased() }).contains(name.lowercased())
    }

    func isCanvasSelected(_ canvas: Canvas) -> Bool {
        selectedCanvases.contains(canvas)
    }

    func getAnnotationCanvases() -> [IdentifiedAnnotationCanvas] {
        annotationCanvasRepo.queryAll()
    }
}
