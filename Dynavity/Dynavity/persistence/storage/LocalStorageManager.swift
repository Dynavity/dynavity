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

    /// Checks if the file in the documents directory
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

// Canvas-specific operations
extension LocalStorageManager: StorageManager {
    private static let canvasFileExt: String = "json"

    func readAllCanvases() throws -> [CanvasDTO] {
        var canvases: [CanvasDTO] = []

        let canvasURLs = try getAllURLsInDocumentDirectory(with: LocalStorageManager.canvasFileExt)
        for url in canvasURLs {
            if let canvas = try? readCanvasFromFile(withURL: url) {
                canvases.append(canvas)
            } else {
                print("Failed to read contents or from file \(url.path)")
                print("Omitting \(url.path)")
            }
        }

        return canvases
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

private enum IOError: Error {
    case readError(String)
    case writeError(String)
}
