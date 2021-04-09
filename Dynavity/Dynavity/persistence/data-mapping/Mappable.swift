protocol Mappable {
    associatedtype Model
    func toModel() -> Model
}
