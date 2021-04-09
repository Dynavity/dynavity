protocol StorageManager {
    func readAllCanvases() throws -> [CanvasDTO]
    func saveCanvas(canvas: CanvasDTO) throws
}
