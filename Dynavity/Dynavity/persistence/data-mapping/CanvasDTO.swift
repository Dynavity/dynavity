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

    init(id: UUID, model: CanvasWithAnnotation) {
        self.id = id
        self.name = model.name
        self.canvasElements = model.canvas.canvasElements
            .filter({ !($0 is UmlElementProtocol) })
            .map({ TypeWrappedCanvasElementDTO(model: $0) })
        self.umlCanvasElements = model.canvas.canvasElements
            .filter({ $0 is UmlElementProtocol })
            .compactMap({
                guard let umlElement = $0 as? UmlElementProtocol else {
                    return nil
                }
                let id = UmlElementId(id: ObjectIdentifier(umlElement).hashValue)
                let identifiedElement = IdentifiedUmlElementWrapper(id: id, umlElement: umlElement)
                return TypeWrappedUmlElementDTO(model: identifiedElement)
            })
        self.umlConnectors = model.canvas.umlConnectors.map({ UmlConnectorDTO(model: $0) })
        self.annotationCanvas = model.annotationCanvas.drawing.dataRepresentation()
    }

    init(model: CanvasWithAnnotation) {
        self.init(id: UUID(), model: model)
    }

    func toModel() -> CanvasWithAnnotation {
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
        return CanvasWithAnnotation(canvas: model, annotationCanvas: annotations)
    }
}

extension CanvasDTO: Codable {}
