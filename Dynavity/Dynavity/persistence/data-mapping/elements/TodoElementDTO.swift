import CoreGraphics
import Foundation

struct TodoElementDTO: CanvasElementDTOProtocol, Mappable {
    struct TodoDTO: Mappable, Codable {
        let label: String
        let isCompleted: Bool

        init(model: Todo) {
            self.label = model.label
            self.isCompleted = model.isCompleted
        }

        func toModel() -> Todo {
            Todo(label: label, isCompleted: isCompleted)
        }
    }

    let canvasProperties: CanvasElementPropertiesDTO

    let todos: [TodoDTO]

    init(model: TodoElement) {
        self.canvasProperties = CanvasElementPropertiesDTO(model: model.canvasProperties)
        self.todos = model.todos.map({ TodoDTO(model: $0) })
    }

    func toModel() -> TodoElement {
        let model = TodoElement(position: canvasProperties.position, todos: todos.map({ $0.toModel() }))
        model.canvasProperties = canvasProperties.toModel()
        return model
    }
}

extension TodoElementDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case canvasProperties, todos
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.canvasProperties = try values.decode(CanvasElementPropertiesDTO.self, forKey: .canvasProperties)
        self.todos = try values.decodeIfPresent([TodoDTO].self, forKey: .todos) ?? []
    }
}
