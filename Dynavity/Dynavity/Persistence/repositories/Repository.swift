import Foundation

protocol Repository {
    associatedtype T
    func queryAll() -> [T]
    func save(model: T) -> Bool
    func delete(model: T) -> Bool
    func deleteMany(models: [T]) -> Bool
}
