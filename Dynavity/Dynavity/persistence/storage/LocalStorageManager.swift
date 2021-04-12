import Foundation

struct LocalStorageManager {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let fileManager = FileManager.default

    private var documentsDirectory: URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    /// Returns the URL of the file in the documents directory
    private func getFileURL(from name: String, ext: String) -> URL {
        documentsDirectory.appendingPathComponent(name).appendingPathExtension(ext)
    }

    /// Checks if the file is in the documents directory
    private func doesFileExist(name: String, ext: String) -> Bool {
        let url = getFileURL(from: name, ext: ext)
        return fileManager.fileExists(atPath: url.path)
    }

    private func readFile(withURL url: URL) -> Data? {
        guard let data = try? Data(contentsOf: url) else {
            return nil
        }
        return data
    }

    private func getAllURLsInDocumentDirectory(with ext: String) throws -> [URL] {
        do {
            let fileUrls = try fileManager.contentsOfDirectory(at: documentsDirectory,
                                                               includingPropertiesForKeys: nil)

            return fileUrls.filter({ $0.pathExtension == ext })
        } catch {
            throw IOError.readError(
                "Error while enumerating files in \(documentsDirectory.path): \(error.localizedDescription)"
            )
        }
    }
}

extension LocalStorageManager: StorageManager {
    private static let canvasFileExt: String = "json"

    func readAllCanvases() throws -> [CanvasDTO] {
        let canvasURLs = try getAllURLsInDocumentDirectory(with: LocalStorageManager.canvasFileExt)
        return canvasURLs.compactMap({ try? readCanvasFromFile(withURL: $0) })
    }

    /// Canvases will be saved in the documents directory with the file name: `\(id).json`
    func saveCanvas(canvas: CanvasDTO) throws {
        // TODO: perform validation here before saving if necessary (e.g. ensure canvas name is unique etc)

        if let encodedData = try? encoder.encode(canvas) {
            let fileURL = getFileURL(from: canvas.id.uuidString, ext: LocalStorageManager.canvasFileExt)
            do {
                try encodedData.write(to: fileURL, options: .atomic)
            } catch {
                throw IOError.writeError("Failed to save canvas: \(error.localizedDescription)")
            }
        }
    }

    func deleteCanvas(canvas: CanvasDTO) throws {
        let fileURL = getFileURL(from: canvas.id.uuidString, ext: LocalStorageManager.canvasFileExt)
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            throw IOError.writeError("Failed to delete canvas: \(error.localizedDescription)")
        }
    }

    private func readCanvasFromFile(withURL url: URL) throws -> CanvasDTO? {
        guard let data = readFile(withURL: url) else {
            return nil
        }

        do {
            let canvas = try decoder.decode(CanvasDTO.self, from: data)
            return canvas
        } catch {
            throw IOError.readError("Attempted to read and decode a corrupted data file: \(url.path)")
        }
    }
}

// MARK: Storage for annotations
extension LocalStorageManager {
    func readAllAnnotationCanvases() throws -> [AnnotationCanvasDTO] {
        let annotationCanvasURLs = try getAllURLsInDocumentDirectory(with: LocalStorageManager.canvasFileExt)
        return annotationCanvasURLs.compactMap({ try? readAnnotationCanvasFromFile(withURL: $0) })
    }

    func saveAnnotationCanvas(annotationCanvas: AnnotationCanvasDTO) throws {
        if let encodedData = try? encoder.encode(annotationCanvas) {
            let fileURL = getFileURL(from: annotationCanvas.id.uuidString, ext: LocalStorageManager.canvasFileExt)
            do {
                try encodedData.write(to: fileURL, options: .atomic)
            } catch {
                throw IOError.writeError("Failed to save canvas: \(error.localizedDescription)")
            }
        }
    }

    func deleteAnnotationCanvas(annotationCanvas: AnnotationCanvasDTO) throws {
        let fileURL = getFileURL(from: annotationCanvas.id.uuidString, ext: LocalStorageManager.canvasFileExt)
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            throw IOError.writeError("Failed to delete canvas: \(error.localizedDescription)")
        }
    }

    private func readAnnotationCanvasFromFile(withURL url: URL) throws -> AnnotationCanvasDTO? {
        guard let data = readFile(withURL: url) else {
            return nil
        }

        do {
            let annotationCanvas = try decoder.decode(AnnotationCanvasDTO.self, from: data)
            return annotationCanvas
        } catch {
            throw IOError.readError("Attempted to read and decode a corrupted data file: \(url.path)")
        }
    }
}

private enum IOError: Error {
    case readError(String)
    case writeError(String)
}
