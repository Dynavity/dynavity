import Foundation
import FirebaseDatabase
import CodableFirebase
import Combine

struct CloudStorageManager {
    let encoder = FirebaseEncoder()
    let decoder = FirebaseDecoder()
    let userId = OnlineCanvas.myUserId
    var database: Database

    init() {
        database = Database.database()
    }

    func readAll() throws -> [OnlineCanvasDTO] {
        // own cloud canvases
        let own = database.reference(withPath: "\(userId)/self")
        let ownFuture = Future<[OnlineCanvasDTO], Never> { callback in
            own.getData { _, snapshot in
                guard let value = snapshot.value as? [String: Any] else {
                    // if something is wrong, 'success' with empty value
                    return callback(.success([]))
                }
                let canvases = value.keys.compactMap { key -> OnlineCanvasDTO? in
                    guard let canvasValue = snapshot.childSnapshot(forPath: key).value else {
                        return nil
                    }
                    return try? decoder.decode(OnlineCanvasDTO.self, from: canvasValue)
                }
                callback(.success(canvases))
            }
        }
        let ownCanvases = FutureSynchronizer(publisher: ownFuture).blockForValue()
        // other cloud canvases (from collab)
        let collab = database.reference(withPath: "\(userId)/collab")
        let collabFuture = Future<[OnlineCanvasDTO], Never> { callback in
            collab.getData { _, snapshot in
                guard let value = snapshot.value,
                      let loaded = try? decoder.decode([ExternalCanvasReference].self, from: value) else {
                    // if something is wrong, 'success' with empty value
                    return callback(.success([]))
                }
                let futures = loaded.map { ref in
                    Future<OnlineCanvasDTO, Never> { callback in
                        let db = database.reference(withPath: "\(ref.userId)/self/\(ref.canvasId)")
                        db.getData { _, snapshot in
                            guard let value = snapshot.value,
                                  let loaded = try? decoder.decode(OnlineCanvasDTO.self, from: value) else {
                                return
                            }
                            callback(.success(loaded))
                        }
                    }
                }
                let canvases = MultiFutureSynchronizer(publishers: futures).blockForValue()
                callback(.success(canvases))
            }
        }
        let collabCanvases = FutureSynchronizer(publisher: collabFuture).blockForValue()
        return (ownCanvases ?? []) + (collabCanvases ?? [])
    }

    func save(model canvas: OnlineCanvasDTO) throws {
        guard let data = try? encoder.encode(canvas) else {
            return
        }
        if userId == canvas.ownerId {
            // save own canvas
            let db = database.reference(withPath: "\(userId)/self/\(canvas.canvas.id)")
            db.setValue(data)
        } else {
            // save other canvas
            let ref = ExternalCanvasReference(userId: canvas.ownerId, canvasId: canvas.canvas.id.uuidString)
            let db = database.reference(withPath: "\(ref.userId)/self/\(ref.canvasId)")
            db.setValue(data)
        }
    }

    func delete(model canvas: OnlineCanvasDTO) throws {
        if userId == canvas.ownerId {
            // delete own canvas
            let db = database.reference(withPath: "\(userId)/self/\(canvas.canvas.id)")
            db.removeValue()
        } else {
            // delete link to other canvas
            let ref = ExternalCanvasReference(userId: canvas.ownerId, canvasId: canvas.canvas.id.uuidString)
            let db = database.reference(withPath: "\(userId)/collab")
            // get the whole array, filter, write back
            db.getData { _, snapshot in
                guard let value = snapshot.value,
                      let loaded = try? decoder.decode([ExternalCanvasReference].self, from: value),
                      let data = try? encoder.encode(loaded.filter { $0 != ref })else {
                    return
                }
                db.setValue(data)
            }
        }
    }
}

// MARK: Struct to help with decoding
struct ExternalCanvasReference: Codable, Equatable {
    let userId: String
    let canvasId: String
}

// MARK: Helper to synchronize asynchronous code
class FutureSynchronizer<T> {
    let publisher: Future<T, Never>
    private var value: T?
    private var cancel: AnyCancellable!

    init(publisher: Future<T, Never>) {
        self.publisher = publisher
    }

    func blockForValue() -> T? {
        let block = DispatchSemaphore(value: 0)
        cancel = publisher.sink { value in
            self.value = value
            block.signal()
        }
        block.wait()
        cancel = nil // no longer needed
        return value
    }
}

class MultiFutureSynchronizer<T> {
    let publishers: [Future<T, Never>]
    private var values: [T] = []
    private var cancels: [AnyCancellable] = []

    init(publishers: [Future<T, Never>]) {
        self.publishers = publishers
    }

    func blockForValue() -> [T] {
        let block = DispatchSemaphore(value: 0)
        for publisher in publishers {
            let cancel = publisher.sink { value in
                self.values.append(value)
                block.signal()
            }
            cancels.append(cancel)
        }
        for _ in publishers {
            block.wait()
        }
        cancels.removeAll() // no longer needed
        return values
    }
}
