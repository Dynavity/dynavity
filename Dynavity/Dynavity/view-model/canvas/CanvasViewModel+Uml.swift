import SwiftUI

// MARK: UML side menu controls button handlers
extension CanvasViewModel {
    func showUmlMenu() {
        shouldShowUmlMenu = true
    }

    func hideUmlMenu() {
        shouldShowUmlMenu = false
    }
}

// MARK: UML diagram utility functions
extension CanvasViewModel {
    func getCanvasUmlConnectors() -> [UmlConnector] {
        canvas.umlConnectors
    }

    private func pointInUmlElement(_ point: CGPoint) -> UmlElementProtocol? {
        let canvasElement = canvas.canvasElements.first { $0 is UmlElementProtocol && $0.containsPoint(point) }
        guard let umlElement = canvasElement as? UmlElementProtocol else {
            return nil
        }
        return umlElement
    }

    /// To remove dependency of `OrthogonalConnector` model with `UmlSelectionOverlayView` view
    private func convertToConnectorAnchor(_ anchor: UmlSelectionOverlayView.ConnectorControlAnchor)
    -> ConnectorConnectingSide {
        switch anchor {
        case .middleTop:
            return .middleTop
        case .middleBottom:
            return .middleBottom
        case .middleLeft:
            return .middleLeft
        case .middleRight:
            return .middleRight
        }
    }

    func handleUmlElementUpdated() {
        guard let element = canvas.getElementBy(id: selectedCanvasElementId) else {
            return
        }
        if element is UmlElementProtocol {
            updateUmlConnections(id: selectedCanvasElementId)
        }
    }

    func updateUmlConnections(id: UUID?) {
        guard let id = id else {
            return
        }
        var idsToRemove: [UUID] = []
        for var connector in canvas.umlConnectors {
            if connector.connects.fromElement != id
                    && connector.connects.toElement != id {
                continue
            }
            idsToRemove.append(connector.id)
            let sourceId = connector.connects.fromElement
            let destId = connector.connects.toElement
            guard let source = canvas.getElementBy(id: sourceId) as? UmlElementProtocol,
                  let dest = canvas.getElementBy(id: destId) as? UmlElementProtocol else {
                return
            }
            let sourceAnchor = connector.connectingSide.fromSide
            let destAnchor = connector.connectingSide.toSide
            let newPoints = OrthogonalConnector(from: source, to: dest)
                .generateRoute(sourceAnchor, destAnchor: destAnchor)
            connector.points = newPoints
            canvas.replaceUmlConnector(connector)
        }
    }
}

// MARK: UML connection point gestures
extension CanvasViewModel {
    func handleConnectionPointTap(_ element: UmlElementProtocol,
                                  anchor: UmlSelectionOverlayView.ConnectorControlAnchor) {
        guard let (startUmlElement, startAnchor) = umlConnectorStart else {
            umlConnectorStart = (umlElement: element, anchor: convertToConnectorAnchor(anchor))
            return
        }
        guard  umlConnectorEnd == nil else {
            return
        }
        let newEndAnchor = convertToConnectorAnchor(anchor)
        umlConnectorEnd = (umlElement: element, anchor: newEndAnchor)
        let points = OrthogonalConnector(from: startUmlElement, to: element)
            .generateRoute(startAnchor, destAnchor: newEndAnchor)
        canvas.addUmlConnector(UmlConnector(points: points,
                                            connects: (fromElement: startUmlElement.id,
                                                       toElement: element.id),
                                            connectingSide: (fromSide: startAnchor,
                                                             toSide: newEndAnchor)))
        umlConnectorStart = nil
        umlConnectorEnd = nil
        selectedCanvasElementId = nil
    }
}

// MARK: UML connector gestures
extension CanvasViewModel {
    func select(umlConnector: UmlConnector) {
        if selectedUmlConnectorId == umlConnector.id {
            selectedUmlConnectorId = nil
            return
        }
        selectedUmlConnectorId = umlConnector.id
    }

    func removeUmlConnector(_ connector: UmlConnector) {
        canvas.removeUmlConnector(connector)
    }
}
