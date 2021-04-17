import Foundation
import PencilKit

struct CanvasDTO: Mappable {
    var id: UUID
    let canvasElements: [TypeWrappedCanvasElementDTO]
    // Stored separately as umlCanvasElements require ID
    let umlDiagram: UmlDiagramDTO
    let annotationCanvas: Data
    let name: String

    init(id: UUID, model: Canvas) {
        self.id = id
        self.name = model.name
        self.canvasElements = model.canvasElements
            .filter({ !($0 is UmlElementProtocol) })
            .map({ TypeWrappedCanvasElementDTO(model: $0) })
        let umlCanvasElements: [TypeWrappedUmlElementDTO] = model.canvasElements
            .compactMap({ $0 as? UmlElementProtocol })
            .map({ umlElement in
                let id = UmlElementId(id: ObjectIdentifier(umlElement).hashValue)
                let identifiedElement = IdentifiedUmlElementWrapper(id: id, umlElement: umlElement)
                return TypeWrappedUmlElementDTO(model: identifiedElement)
            })
        let umlConnectors = model.umlConnectors.map({ UmlConnectorDTO(model: $0) })
        self.umlDiagram = UmlDiagramDTO(elements: umlCanvasElements, connectors: umlConnectors)
        self.annotationCanvas = model.annotationCanvas.drawing.dataRepresentation()
    }

    init(model: Canvas) {
        self.init(id: UUID(), model: model)
    }

    func toModel() -> Canvas {
        let model = Canvas()
        model.name = name
        for ele in canvasElements {
            model.addElement(ele.toModel())
        }

        let uml = umlDiagram.toModel()
        uml.elements.forEach(model.addElement)
        uml.connectors.forEach(model.addUmlConnector)

        let drawing = try? PKDrawing(data: annotationCanvas)
        let annotations = AnnotationCanvas(drawing: drawing ?? PKDrawing())
        model.annotationCanvas = annotations

        return Canvas(canvas: model)
    }
}

extension CanvasDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, canvasElements, umlDiagram, annotationCanvas, name
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(UUID.self, forKey: .id)
        self.canvasElements = try values.decodeIfPresent([TypeWrappedCanvasElementDTO].self, forKey: .canvasElements)
            ?? []
        self.umlDiagram = try values.decodeIfPresent(UmlDiagramDTO.self, forKey: .umlDiagram) ?? UmlDiagramDTO(elements: [], connectors: [])
        self.annotationCanvas = try values.decode(Data.self, forKey: .annotationCanvas)
        self.name = try values.decode(String.self, forKey: .name)
    }
}
