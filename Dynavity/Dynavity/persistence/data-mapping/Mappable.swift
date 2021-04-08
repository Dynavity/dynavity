protocol Mappable {
    associatedtype T
    func toModel() -> T
}
