protocol StorageManager {
    func readAllCanvases() throws -> [CanvasDTO]
    func saveCanvas(canvas: CanvasDTO) throws
    func deleteCanvas(canvas: CanvasDTO) throws

    func readAllAnnotationCanvases() throws -> [AnnotationCanvasDTO]
    func saveAnnotationCanvas(annotationCanvas: AnnotationCanvasDTO) throws
    func deleteAnnotationCanvas(annotationCanvas: AnnotationCanvasDTO) throws
}
