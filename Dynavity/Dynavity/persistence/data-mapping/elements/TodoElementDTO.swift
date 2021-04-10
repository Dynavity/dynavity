import CoreGraphics
import Foundation

struct TodoElementDTO: CanvasElementProtocolDTO, Mappable {
    struct TodoDTO: Mappable, Codable {
        let id: UUID
        let label: String
        let isCompleted: Bool

        init(model: Todo) {
            self.id = model.id
            self.label = model.label
            self.isCompleted = model.isCompleted
        }

        func toModel() -> Todo {
            Todo(id: id, label: label, isCompleted: isCompleted)
        }
    }

    let canvasProperties: CanvasElementPropertiesDTO

    let todos: [TodoDTO]

    init(model: TodoElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.todos = model.todos.map({ TodoDTO(model: $0) })
    }

    func toModel() -> TodoElement {
        let model = TodoElement(position: canvasProperties.position)
        model.canvasProperties = canvasProperties.toModel()
        model.todos = todos.map({ $0.toModel() })
        return model
    }
}
