import Foundation
import Combine

/// Allows waiting for some `Future` to complete, blocking until a value is available.
class FutureSynchronizer<T> {
    let publisher: Future<T, Never>
    private var value: T?
    private var cancel: AnyCancellable!

    init(publisher: Future<T, Never>) {
        self.publisher = publisher
    }

    func blockForValue() -> T? {
        let block = DispatchSemaphore(value: 0)
        cancel = publisher.sink { [weak self] value in
            self?.value = value
            block.signal()
        }
        block.wait()
        cancel = nil // no longer needed
        return value
    }
}
