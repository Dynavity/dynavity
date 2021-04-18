import Foundation
import FirebaseDatabase
import CodableFirebase
import Combine
import PencilKit

struct CloudStorageManager: OnlineStorageManagerProtocol {
    let encoder = FirebaseEncoder()
    let decoder = FirebaseDecoder()
    let userId = OnlineCanvasDTO.myUserId
    var database = Database.database()

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
        let ownCanvases = FutureSynchronizer(publisher: ownFuture).blockForValue() ?? []
        // other cloud canvases (from collab)
        let collab = database.reference(withPath: "\(userId)/collab")
        let collabListFuture = Future<[ExternalCanvasReference], Never> { callback in
            collab.getData { _, snapshot in
                guard let value = snapshot.value,
                      let loaded = try? decoder.decode([ExternalCanvasReference].self, from: value) else {
                    // if something is wrong, 'success' with empty value
                    return callback(.success([]))
                }
                callback(.success(loaded))
            }
        }
        guard let collabList = FutureSynchronizer(publisher: collabListFuture).blockForValue() else {
            return ownCanvases
        }
        let collabFuture = collabList.map { ref in
            Future<OnlineCanvasDTO?, Never> { callback in
                let db = database.reference(withPath: "\(ref.ownerId)/self/\(ref.canvasName)")
                db.getData { _, snapshot in
                    guard let value = snapshot.value,
                          let loaded = try? decoder.decode(CanvasDTO.self, from: value) else {
                        return callback(.success(nil))
                    }
                    let canvas = OnlineCanvasDTO(ownerId: ref.ownerId, canvas: loaded)
                    callback(.success(canvas))
                }
            }
        }
        let collabCanvases = MultiFutureSynchronizer(publishers: collabFuture).blockForValue()
            .compactMap { $0 }
        return ownCanvases + collabCanvases
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

    func importCanvas(ownerId: String, canvasName: String) throws -> OnlineCanvasDTO? {
        // check if canvas exists, and retrieve it if it does
        let db = database.reference(withPath: "\(ownerId)/self/\(canvasName)")
        let checkFuture = Future<OnlineCanvasDTO?, Never> { callback in
            db.getData { _, snapshot in
                guard let value = snapshot.value,
                      let loaded = try? decoder.decode(CanvasDTO.self, from: value) else {
                    return callback(.success(nil))
                }
                let canvas = OnlineCanvasDTO(ownerId: ownerId, canvas: loaded)
                callback(.success(canvas))
            }
        }
        guard let canvas = FutureSynchronizer(publisher: checkFuture).blockForValue() else {
            return nil
        }
        // success, add to current collab list
        let collab = database.reference(withPath: "\(userId)/collab")
        let collabFuture = Future<Void, Never> { callback in
            collab.getData { _, snapshot in
                let ref = ExternalCanvasReference(ownerId: ownerId, canvasName: canvasName)
                guard let value = snapshot.value,
                      var loaded = try? decoder.decode([ExternalCanvasReference].self, from: value) else {
                    collab.setValue(try? encoder.encode([ref]))
                    return callback(.success(Void()))
                }
                loaded.append(ref)
                collab.setValue(try? encoder.encode(loaded))
                callback(.success(Void()))
            }
        }
        FutureSynchronizer(publisher: collabFuture).blockForValue()

        // return imported canvas
        return canvas
    }

    func addChangeListeners(model: OnlineCanvas) {
        let db = database.reference(withPath: "\(model.ownerId)/self/\(model.name)")
        db.child("canvasElements").observe(.value) { snapshot in
            guard let value = snapshot.value,
                  let loaded = try? decoder.decode([TypeWrappedCanvasElementDTO].self, from: value) else {
                return
            }
            model.replace(canvasElements: loaded.map { $0.toModel() })
        }
        db.child("annotationCanvas").observe(.value) { snapshot in
            guard let value = snapshot.value,
                  let loaded = try? decoder.decode(Data.self, from: value) else {
                return
            }
            let drawing = (try? PKDrawing(data: loaded)) ?? PKDrawing()
            model.replace(annotation: AnnotationCanvas(drawing: drawing))
        }
        db.child("umlDiagram").observe(.value) { snapshot in
            guard let value = snapshot.value,
                  let loaded = try? decoder.decode(UmlDiagramDTO.self, from: value) else {
                return
            }
            let diagram = loaded.toModel()
            model.replace(umlElements: diagram.elements, umlConnectors: diagram.connectors)
        }
    }
}

// struct to help with decoding
struct ExternalCanvasReference: Codable, Equatable {
    let ownerId: String
    let canvasName: String
}
