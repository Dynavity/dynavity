import CoreGraphics
import SwiftUI
import Foundation

class GraphMapViewModel: ObservableObject {
    @Published var backlinkEngine = BacklinkEngine()

    private var selectedNodeOriginalPosition: CGPoint?
    @Published var selectedNode: BacklinkNode?

    init() {
        initialiseBacklinkEngine()
    }

    func getNodes() -> [BacklinkNode] {
        backlinkEngine.nodes
    }

    func getEdges() -> [BacklinkEdge] {
        backlinkEngine.edges
    }

    private func initialiseBacklinkEngine() {
        let nodes: [BacklinkNode] = (0..<20).map { i in
            BacklinkNode(id: UUID(), name: "Node \(i)", position: CGPoint(x: Int.random(in: 0...700),
                                                                          y: Int.random(in: 0...700)))
        }

        for i in 0..<nodes.endIndex - 1 {
            backlinkEngine.addLinkBetween(nodes[i], and: nodes[i + 1])
        }
    }
}

// MARK: Node Dragging Handling
extension GraphMapViewModel {
    func hitTest(tapPos: CGPoint, viewportSize: CGSize,
                 viewportZoomScale: CGFloat, viewportOriginOffset: CGPoint) {
        for node in self.getNodes() {
            let processedPosition = getPositionRelativeToViewport(point: node.position,
                                                                  viewportSize: viewportSize,
                                                                  viewportZoomScale: viewportZoomScale,
                                                                  viewportOriginOffset: viewportOriginOffset)
            let dist = tapPos.distance(to: processedPosition) / viewportZoomScale

            if dist < NodeView.radius {
                selectedNode = node
                selectedNodeOriginalPosition = node.position
            }
        }
    }

    func handleNodeDragChange(_ value: DragGesture.Value, viewportZoomScale: CGFloat) {
        processNodeTranslation(translation: value.translation, viewportZoomScale: viewportZoomScale)
    }

    func handleNodeDragEnd(_ value: DragGesture.Value, viewportZoomScale: CGFloat) {
        processNodeTranslation(translation: value.translation, viewportZoomScale: viewportZoomScale)
        selectedNodeOriginalPosition = nil
        selectedNode = nil
    }

    private func processNodeTranslation(translation: CGSize, viewportZoomScale: CGFloat) {
        guard let selectedNode = selectedNode,
              let selectedNodeOriginalPosition = selectedNodeOriginalPosition else {
            return
        }

        let scaledDownTranslation = translation / viewportZoomScale
        let updatedPos = selectedNodeOriginalPosition + scaledDownTranslation
        backlinkEngine.moveBacklinkNode(selectedNode, to: updatedPos)
    }

    private func getPositionRelativeToViewport(point: CGPoint,
                                               viewportSize: CGSize,
                                               viewportZoomScale: CGFloat,
                                               viewportOriginOffset: CGPoint) -> CGPoint {
        point
            .scale(by: viewportZoomScale)
            .translateBy(x: viewportSize.width / 2, y: viewportSize.height / 2)
            .translateBy(x: viewportOriginOffset.x, y: viewportOriginOffset.y)
    }
}
