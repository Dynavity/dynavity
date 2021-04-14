import SwiftUI

class CanvasSelectionViewModel: ObservableObject {
    static let canvasNameLengthLimit = 20
    private let canvasRepo = CanvasRepository()

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

    func importCanvas(name: String, owner: String) -> Bool {
        let result = canvasRepo.importCanvas(ownerId: owner, canvasName: name)
        self.objectWillChange.send()
        return result
    }

    // A string is a valid canvas name if and only if it is non-empty, consists of only
    // alphanumeric characters, is unique, and is less than 20 characters long. Spaces are allowed.
    // Canvas names are not case-sensitive.
    func isValidCanvasName(name: String) -> Bool {
        let consistsOfOnlyAlphanumeric = name.range(of: "[^a-zA-Z0-9 ]", options: .regularExpression) == nil
        let isWithinLengthLimit = name.count < CanvasSelectionViewModel.canvasNameLengthLimit
        return !name.isEmpty && consistsOfOnlyAlphanumeric && isCanvasNameUnique(name: name) && isWithinLengthLimit
    }

    func getCanvasWithName(name: String) -> Canvas? {
        canvasRepo.queryAll().first(where: { $0.name == name })
    }

    // Case-insensitive checking
    private func isCanvasNameUnique(name: String) -> Bool {
        !canvasRepo.queryAll().map({ $0.name.lowercased() }).contains(name.lowercased())
    }

    func isCanvasSelected(_ canvas: Canvas) -> Bool {
        selectedCanvases.contains(canvas)
    }
}
