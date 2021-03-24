import SwiftUI

protocol ViewFactory {
    associatedtype View
    func createView(element: CanvasElementProtocol) -> View
}
