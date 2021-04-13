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
    private func getFileURL(name: String, ext: String) -> URL {
        documentsDirectory.appendingPathComponent(name).appendingPathExtension(ext)
    }

    /// Checks if the file is in the documents directory
    private func doesFileExist(name: String, ext: String) -> Bool {
        let url = getFileURL(name: name, ext: ext)
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

// MARK: Canvas
extension LocalStorageManager: StorageManager {
    private static let canvasFileExt: String = "json"

    func readAllCanvases() throws -> [CanvasDTO] {
        let canvasURLs = try getAllURLsInDocumentDirectory(with: LocalStorageManager.canvasFileExt)
        return canvasURLs.compactMap({ try? readCanvasFromFile(withURL: $0) })
    }

    /// Canvases will be saved in the documents directory with the file name: `\(id).json`
    func saveCanvas(canvas: CanvasDTO) throws {
        if let encodedData = try? encoder.encode(canvas) {
            let fileURL = getFileURL(name: canvas.id.uuidString, ext: LocalStorageManager.canvasFileExt)
            do {
                try encodedData.write(to: fileURL, options: .atomic)
            } catch {
                throw IOError.writeError("Failed to save canvas: \(error.localizedDescription)")
            }
        }
    }

    func deleteCanvas(canvas: CanvasDTO) throws {
        let fileURL = getFileURL(name: canvas.id.uuidString, ext: LocalStorageManager.canvasFileExt)
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
            return try decoder.decode(CanvasDTO.self, from: data)
        } catch {
            throw IOError.readError("Attempted to read and decode a corrupted data file: \(url.path)")
        }
    }
}

// MARK: Backlink Engine
extension LocalStorageManager {
    private static let backlinkFileName: String = "backlink"
    private static let backlinkFileExt: String = "graph"

    func readBacklinkEngine() throws -> BacklinkEngineDTO? {
        let url = getFileURL(name: LocalStorageManager.backlinkFileName,
                             ext: LocalStorageManager.backlinkFileExt)
        return try? readBacklinkEngineFromFile(withURL: url)
    }

    func saveBacklinkEngine(backlinkEngine: BacklinkEngineDTO) throws {
        if let encodedData = try? encoder.encode(backlinkEngine) {
            let url = getFileURL(name: LocalStorageManager.backlinkFileName,
                                 ext: LocalStorageManager.backlinkFileExt)
            do {
                try encodedData.write(to: url, options: .atomic)
            } catch {
                throw IOError.writeError("Failed to save backlink engine: \(error.localizedDescription)")
            }
        }
    }

    private func readBacklinkEngineFromFile(withURL url: URL) throws -> BacklinkEngineDTO? {
        guard let data = readFile(withURL: url) else {
            return nil
        }

        do {
            return try decoder.decode(BacklinkEngineDTO.self, from: data)
        } catch {
            throw IOError.readError("Attempted to read and decode a corrupted data file: \(url.path)")
        }
    }
}

private enum IOError: Error {
    case readError(String)
    case writeError(String)
}
