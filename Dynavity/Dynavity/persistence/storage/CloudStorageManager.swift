import Foundation
import FirebaseDatabase
import CodableFirebase
import Combine

struct CloudStorageManager: OnlineStorageManager {
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
                    guard let canvasValue = snapshot.childSnapshot(forPath: key).value,
                          let loaded = try? decoder.decode(CanvasDTO.self, from: canvasValue) else {
                        return nil
                    }
                    return OnlineCanvasDTO(ownerId: userId, canvas: loaded)
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
                        let db = database.reference(withPath: "\(ref.ownerId)/self/\(ref.canvasName)")
                        db.getData { _, snapshot in
                            guard let value = snapshot.value,
                                  let loaded = try? decoder.decode(CanvasDTO.self, from: value) else {
                                return
                            }
                            let canvas = OnlineCanvasDTO(ownerId: ref.ownerId, canvas: loaded)
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
        guard let data = try? encoder.encode(canvas.canvas) else {
            return
        }
        if userId == canvas.ownerId {
            // save own canvas
            let db = database.reference(withPath: "\(userId)/self/\(canvas.canvas.name)")
            db.setValue(data)
        } else {
            // save other canvas
            let ref = ExternalCanvasReference(ownerId: canvas.ownerId, canvasName: canvas.canvas.name)
            let db = database.reference(withPath: "\(ref.ownerId)/self/\(ref.canvasName)")
            db.setValue(data)
        }
    }

    func delete(model canvas: OnlineCanvasDTO) throws {
        if userId == canvas.ownerId {
            // delete own canvas
            let db = database.reference(withPath: "\(userId)/self/\(canvas.canvas.name)")
            db.removeValue()
        } else {
            // delete link to other canvas
            let ref = ExternalCanvasReference(ownerId: canvas.ownerId, canvasName: canvas.canvas.name)
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

// struct to help with decoding
struct ExternalCanvasReference: Codable, Equatable {
    let ownerId: String
    let canvasName: String
}
