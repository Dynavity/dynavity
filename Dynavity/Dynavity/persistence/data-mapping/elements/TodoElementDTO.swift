import CoreGraphics
import Foundation

struct TodoElementDTO: CanvasElementProtocolDTO, Mappable {
    typealias T = TodoElement

    struct TodoDTO: Mappable, Codable {
        let id: UUID
        let label: String
        let isCompleted: Bool

        func toModel() -> Todo {
            Todo(id: id, label: label, isCompleted: isCompleted)
        }
    }

    let position: CGPoint
    let width: CGFloat
    let height: CGFloat
    let rotation: Double

    let todos: [TodoDTO]

    func toModel() -> TodoElement {
        let model = TodoElement(position: position)
        model.width = width
        model.height = height
        model.rotation = rotation
        model.todos = todos.map({ $0.toModel() })
        return model
    }
}
