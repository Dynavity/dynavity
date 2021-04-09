import Foundation

protocol Repository {
    associatedtype T
    func queryAll() -> [T]
//    func query(with predicate: NSPredicate,
//               sortDescriptors: [NSSortDescriptor]) -> Observable<[T]>
//    func save(entity: T) -> Observable<Void>
//    func delete(entity: T) -> Observable<Void>
}
