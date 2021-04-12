import Foundation
import FirebaseDatabase
import CodableFirebase
import Combine

struct CloudStorageManager {
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
                // keys are unimportant here since we want all canvases anyway
                let dto = value.values.compactMap {
                    try? FirebaseDecoder().decode(CanvasDTO.self, from: $0)
                }
                let canvases = dto.map { OnlineCanvasDTO(ownerId: userId, canvas: $0) }
                callback(.success(canvases))
            }
        }
        let ownCanvases = FutureSynchronizer(publisher: ownFuture).blockForValue()
        // other cloud canvases (from collab)
        let collab = database.reference(withPath: "\(userId)/collab")
        let collabFuture = Future<[OnlineCanvasDTO], Never> { callback in
            collab.getData { _, snapshot in
                guard let value = snapshot.value,
                      let loaded = try? FirebaseDecoder().decode([ExternalCanvasReference].self, from: value) else {
                    // if something is wrong, 'success' with empty value
                    return callback(.success([]))
                }
                let futures = loaded.map { ref in
                    Future<OnlineCanvasDTO, Never> { callback in
                        let db = database.reference(withPath: "\(ref.userId)/self/\(ref.canvasId)")
                        db.getData { _, snapshot in
                            guard let value = snapshot.value,
                                  let loaded = try? FirebaseDecoder().decode(CanvasDTO.self, from: value) else {
                                return
                            }
                            let canvas = OnlineCanvasDTO(ownerId: ref.userId, canvas: loaded)
                            callback(.success(canvas))
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
        if userId == canvas.ownerId {
            // save own canvas
            let db = database.reference(withPath: "\(userId)/self/\(canvas.canvas.id)")
            db.setValue(canvas)
        } else {
            // save other canvas
            let ref = ExternalCanvasReference(userId: canvas.ownerId, canvasId: canvas.canvas.id.uuidString)
            let db = database.reference(withPath: "\(ref.userId)/self/\(ref.canvasId)")
            db.setValue(canvas)
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
                      let loaded = try? FirebaseDecoder().decode([ExternalCanvasReference].self, from: value) else {
                    return
                }
                db.setValue(loaded.filter { $0 != ref })
            }
        }
    }
}

// MARK: Structs to help with decoding
struct ExternalCanvasReference: Codable, Equatable {
    let userId: String
    let canvasId: String
}

// MARK: Helper to synchronize asynchronous code
class FutureSynchronizer<T> {
    let publisher: Future<T, Never>
    private var value: T?

    init(publisher: Future<T, Never>) {
        self.publisher = publisher
    }

    func blockForValue() -> T? {
        guard value == nil else {
            return value
        }
        let block = DispatchSemaphore(value: 0)
        _ = publisher.sink { value in
            self.value = value
            block.signal()
        }
        block.wait()
        return value
    }
}

class MultiFutureSynchronizer<T> {
    let publishers: [Future<T, Never>]
    private var values: [T] = []

    init(publishers: [Future<T, Never>]) {
        self.publishers = publishers
    }

    func blockForValue() -> [T] {
        let block = DispatchSemaphore(value: 0)
        for publisher in publishers {
            _ = publisher.sink { value in
                self.values.append(value)
                block.signal()
            }
        }
        for _ in publishers {
            block.wait()
        }
        return values
    }
}
