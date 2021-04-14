import Foundation
import PencilKit

struct CanvasDTO: Mappable {
    var id: UUID
    let canvasElements: [TypeWrappedCanvasElementDTO]
    // Stored separately as umlCanvasElements require ID
    let umlCanvasElements: [TypeWrappedUmlElementDTO]
    let umlConnectors: [UmlConnectorDTO]
    let annotationCanvas: Data
    let name: String

    init(id: UUID, model: Canvas) {
        self.id = id
        self.name = model.name
        self.canvasElements = model.canvasElements
            .filter({ !($0 is UmlElementProtocol) })
            .map({ TypeWrappedCanvasElementDTO(model: $0) })
        self.umlCanvasElements = model.canvasElements
            .filter({ $0 is UmlElementProtocol })
            .compactMap({
                guard let umlElement = $0 as? UmlElementProtocol else {
                    return nil
                }
                let id = UmlElementId(id: ObjectIdentifier(umlElement).hashValue)
                let identifiedElement = IdentifiedUmlElementWrapper(id: id, umlElement: umlElement)
                return TypeWrappedUmlElementDTO(model: identifiedElement)
            })
        self.umlConnectors = model.umlConnectors.map({ UmlConnectorDTO(model: $0) })
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

        var identifiedUmlElements: [IdentifiedUmlElementWrapper] = []
        for ele in umlCanvasElements {
            let elementModel = ele.toModel()
            identifiedUmlElements.append(elementModel)
            model.addElement(elementModel.umlElement)
        }

        for connector in umlConnectors {
            let connectorModel = connector.toModel(umlElements: identifiedUmlElements)
            model.addUmlConnector(connectorModel)
        }

        let drawing = try? PKDrawing(data: annotationCanvas)
        let annotations = AnnotationCanvas(drawing: drawing ?? PKDrawing())
        model.annotationCanvas = annotations

        return Canvas(canvas: model)
    }
}

extension CanvasDTO: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, canvasElements, umlCanvasElements, umlConnectors, annotationCanvas, name
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(UUID.self, forKey: .id)
        self.canvasElements = try values.decodeIfPresent([TypeWrappedCanvasElementDTO].self, forKey: .canvasElements)
            ?? []
        self.umlCanvasElements = try values.decodeIfPresent([TypeWrappedUmlElementDTO].self, forKey: .umlCanvasElements)
            ?? []
        self.umlConnectors = try values.decodeIfPresent([UmlConnectorDTO].self, forKey: .umlConnectors) ?? []
        self.annotationCanvas = try values.decode(Data.self, forKey: .annotationCanvas)
        self.name = try values.decode(String.self, forKey: .name)
    }
}
