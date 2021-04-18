import SwiftUI

protocol ViewFactoryProtocol {
    associatedtype View
    func createView(element: CanvasElementProtocol) -> View
}
