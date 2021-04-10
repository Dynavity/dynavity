protocol Mappable {
    associatedtype Model
    init(model: Model)
    func toModel() -> Model
}
