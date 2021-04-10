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
        guard let element = selectedCanvasElement as? UmlElementProtocol else {
            return
        }
        updateUmlConnections(element: element)
    }

    func updateUmlConnections(element: UmlElementProtocol) {
        for connector in canvas.umlConnectors {
            if connector.connects.fromElement !== element
                    && connector.connects.toElement !== element {
                continue
            }
            let sourceElement = connector.connects.fromElement
            let destElement = connector.connects.toElement
            let sourceAnchor = connector.connectingSide.fromSide
            let destAnchor = connector.connectingSide.toSide
            let newPoints = OrthogonalConnector(from: sourceElement, to: destElement)
                .generateRoute(sourceAnchor, destAnchor: destAnchor)
            connector.points = newPoints
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
                                            connects: (fromElement: startUmlElement,
                                                       toElement: element),
                                            connectingSide: (fromSide: startAnchor,
                                                             toSide: newEndAnchor)))
        umlConnectorStart = nil
        umlConnectorEnd = nil
        selectedCanvasElement = nil
    }
}

// MARK: UML connector gestures
extension CanvasViewModel {
    func select(umlConnector: UmlConnector) {
        if selectedUmlConnector != nil {
            selectedUmlConnector = nil
            return
        }
        selectedUmlConnector = umlConnector
    }

    func removeUmlConnector(_ connector: UmlConnector) {
        canvas.removeUmlConnector(connector)
    }
}
