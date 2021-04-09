import Combine

// Conforming to `AnyObject` forces this to be a class-only protocol.
protocol AnyObservableObject: AnyObject {
    var objectWillChange: ObservableObjectPublisher { get }
}
