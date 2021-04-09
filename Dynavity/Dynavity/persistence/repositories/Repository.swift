import Foundation

protocol Repository {
    associatedtype T
    func queryAll() -> [T]
    func save(model: T) -> Bool
//    func query(with predicate: NSPredicate,
//               sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
//    func delete(model: T) -> Observable<Void>
}
