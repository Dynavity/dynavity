import SwiftUI

protocol UmlElementProtocol: CanvasElementProtocol {
    var label: String { get set }
    var umlType: UmlType { get }
    var umlShape: UmlShape { get }
}
