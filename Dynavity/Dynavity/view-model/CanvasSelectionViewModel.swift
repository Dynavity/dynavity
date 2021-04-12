import SwiftUI

class CanvasSelectionViewModel: ObservableObject {
    private let canvasRepo = CanvasRepository()

    @Published var selectedCanvases: [CanvasWithAnnotation] = []
    @Published var searchQuery: String = ""

    func getCanvases() -> [CanvasWithAnnotation] {
        canvasRepo.queryAll()
    }

    func getFilteredCanvases() -> [CanvasWithAnnotation] {
        getCanvases().filter {
            if searchQuery.isEmpty {
                return true
            }
            return $0.name.lowercased().contains(self.searchQuery.lowercased())
        }
    }

    func toggleSelectedCanvas(_ canvas: CanvasWithAnnotation) {
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

    func deleteCanvas(_ canvas: CanvasWithAnnotation) {
        canvasRepo.delete(model: canvas)
        self.objectWillChange.send()
    }

    func createCanvas(name: String) {
        let canvas = Canvas()
        canvas.name = name
        let canvasWithAnnotation = CanvasWithAnnotation(canvas: canvas, annotationCanvas: Data())
        canvasRepo.save(model: canvasWithAnnotation)
        self.objectWillChange.send()
    }

    func renameCanvas(_ canvas: CanvasWithAnnotation, updatedName: String) {
        let newCanvas = CanvasWithAnnotation(canvas: canvas.canvas, annotationCanvas: canvas.annotationCanvas)
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

    func isCanvasSelected(_ canvas: CanvasWithAnnotation) -> Bool {
        selectedCanvases.contains(canvas)
    }
}
