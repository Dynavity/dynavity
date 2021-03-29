/// A type-erased identifiable value that has a name.
struct AnyNamedIdentifiable: Identifiable {
    let id: AnyHashable
    let name: String

    init<T: NamedIdentifiable>(_ namedIdentifiable: T) {
        self.id = namedIdentifiable.id
        self.name = namedIdentifiable.name
    }
}

extension AnyNamedIdentifiable: Hashable {}
