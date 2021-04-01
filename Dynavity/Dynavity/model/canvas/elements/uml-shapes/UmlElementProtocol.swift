import SwiftUI

protocol UmlElementProtocol: CanvasElementProtocol {
    var label: String { get set }
    var umlType: UmlTypes { get }
    var umlShape: UmlShapes { get }
}
