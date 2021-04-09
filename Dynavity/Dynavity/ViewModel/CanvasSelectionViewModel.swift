import SwiftUI

class CanvasSelectionViewModel: ObservableObject {
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
            selectedCanvases = selectedCanvases.filter({ $0 != canvas })
        } else {
            selectedCanvases.append(canvas)
        }
    }

    func clearSelectedCanvases() {
        selectedCanvases = []
    }

    func deleteSelectedCanvases() -> Bool {
        canvasRepo.deleteMany(models: selectedCanvases)
    }

    func isCanvasSelected(_ canvas: Canvas) -> Bool {
        selectedCanvases.contains(canvas)
    }
}
