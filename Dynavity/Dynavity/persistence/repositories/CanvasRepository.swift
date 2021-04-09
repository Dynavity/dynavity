struct CanvasRepository: Repository {
    typealias T = Canvas

    let storageManager: StorageManager = LocalStorageManager()

    func queryAll() -> [Canvas] {
        let canvasDTOs = (try? storageManager.readAllCanvases()) ?? []
        return canvasDTOs.map({ $0.toModel() })
    }
}
