import SwiftUI

struct TodoElement: CanvasElementProtocol {
    // MARK: CanvasElementProtocol
    var id = UUID()
    var position: CGPoint
    var width: CGFloat = 500.0
    var height: CGFloat = 500.0
    var rotation: Double = .zero
    var minimumWidth: CGFloat {
        240.0
    }
    var minimumHeight: CGFloat {
        60.0
    }
    var observers = [ElementChangeListener]()

    // MARK: TodosElement-specific attributes
    var todos: [Todo] = []

    mutating func removeTodo(at index: Int) {
        todos.remove(at: index)
        notifyObservers()
    }

    mutating func addTodo(label: String) {
        todos.append(Todo(label: label))
        notifyObservers()
    }
}

extension TodoElement: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, position, width, height, rotation, todos
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        func getOrDefault<T: Decodable>(type: T.Type, key: CodingKeys, orElse: T) -> T {
            (try? container.decode(type, forKey: key)) ?? orElse
        }
        self.init(id: try container.decode(UUID.self, forKey: .id),
                  position: try container.decode(CGPoint.self, forKey: .position),
                  width: try container.decode(CGFloat.self, forKey: .width),
                  height: try container.decode(CGFloat.self, forKey: .height),
                  rotation: try container.decode(Double.self, forKey: .rotation),
                  todos: getOrDefault(type: [Todo].self, key: .todos, orElse: []))
    }
}
