import Foundation
import Combine

/// Allows waiting for multiple `Future`s to complete, blocking until a value is received from every `Future`.
class MultiFutureSynchronizer<T> {
    let publishers: [Future<T, Never>]
    private var values: [T] = []
    private var cancels: [AnyCancellable] = []

    init(publishers: [Future<T, Never>]) {
        self.publishers = publishers
    }

    func blockForValue() -> [T] {
        let block = DispatchSemaphore(value: 0)
        for publisher in publishers {
            let cancel = publisher.sink { value in
                self.values.append(value)
                block.signal()
            }
            cancels.append(cancel)
        }
        for _ in publishers {
            block.wait()
        }
        cancels.removeAll() // no longer needed
        return values
    }
}
