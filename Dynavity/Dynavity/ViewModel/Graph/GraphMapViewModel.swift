import CoreGraphics
import SwiftUI
import Foundation

// TODO: remove this once canvases are fully integrated
let testId = UUID()

class GraphMapViewModel: ObservableObject {
    @Published var backlinkEngine = BacklinkEngine()

    private var draggedNodeOriginalPosition: CGPoint?
    @Published var draggedNode: BacklinkNode?

    @Published var longPressedNode: BacklinkNode?

    init() {
        initialiseBacklinkEngine()
    }

    func getNodes() -> [BacklinkNode] {
        backlinkEngine.nodes
    }

    func getEdges() -> [BacklinkEdge] {
        backlinkEngine.edges
    }

    // TODO: replace the implementation of this function: load from file and rebuild the links
    private func initialiseBacklinkEngine() {
        backlinkEngine.addNode(id: testId, name: "TEST")

        let ids: [UUID] = (0..<20).map({ _ in UUID() })
        for id in ids {
            backlinkEngine.addNode(id: id, name: id.uuidString)
        }

        for i in 0..<ids.endIndex - 1 {
            backlinkEngine.addLinkBetween(testId, and: ids[i])
            backlinkEngine.addLinkBetween(ids[i], and: ids[i + 1])
        }
    }

    func getLinkedNodes(for id: UUID) -> [BacklinkNode] {
        backlinkEngine.getBacklinks(for: id).sorted(by: { $0.name < $1.name })
    }

    func getUnlinkedNodes(for id: UUID) -> [BacklinkNode] {
        let unlinkedNodes = Set(self.getNodes()).subtracting(self.getLinkedNodes(for: id))

        return Array(unlinkedNodes)
            // Exclude the input node
            .filter({ $0.id != id })
            .sorted(by: { $0.name < $1.name })
    }

    func addLinkBetween(_ firstItemId: UUID, and secondItemId: UUID) {
        backlinkEngine.addLinkBetween(firstItemId, and: secondItemId)
    }

    func removeLinkBetween(_ firstItemId: UUID, and secondItemId: UUID) {
        backlinkEngine.removeLinkBetween(firstItemId, and: secondItemId)
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
                draggedNode = node
                draggedNodeOriginalPosition = node.position
            }
        }
    }

    func handleNodeDragChange(_ value: DragGesture.Value, viewportZoomScale: CGFloat) {
        processNodeTranslation(translation: value.translation, viewportZoomScale: viewportZoomScale)
    }

    func handleNodeDragEnd(_ value: DragGesture.Value, viewportZoomScale: CGFloat) {
        processNodeTranslation(translation: value.translation, viewportZoomScale: viewportZoomScale)
        draggedNodeOriginalPosition = nil
        draggedNode = nil
    }

    private func processNodeTranslation(translation: CGSize, viewportZoomScale: CGFloat) {
        guard let draggedNode = draggedNode,
              let draggedNodeOriginalPosition = draggedNodeOriginalPosition else {
            return
        }

        let scaledDownTranslation = translation / viewportZoomScale
        let updatedPos = draggedNodeOriginalPosition + scaledDownTranslation
        backlinkEngine.moveBacklinkNode(draggedNode, to: updatedPos)
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
