import CoreGraphics
import SwiftUI
import Foundation

class GraphMapViewModel: ObservableObject {
    private let backlinkRepo = BacklinkRepository()

    @Published var backlinkEngine: BacklinkEngine

    private var draggedNodeOriginalPosition: CGPoint?
    @Published var draggedNode: BacklinkNode?

    @Published var longPressedNode: BacklinkNode?

    init() {
        let backlinkEngine = backlinkRepo.queryAll().first ?? BacklinkEngine()
        self.backlinkEngine = backlinkEngine
    }

    func getNodes() -> [BacklinkNode] {
        backlinkEngine.nodes
    }

    func getEdges() -> [BacklinkEdge] {
        backlinkEngine.edges
    }

    func getLinkedNodes(for name: String) -> [BacklinkNode] {
        backlinkEngine.getBacklinks(for: name).sorted(by: { $0.name < $1.name })
    }

    func getUnlinkedNodes(for name: String) -> [BacklinkNode] {
        let unlinkedNodes = Set(self.getNodes()).subtracting(self.getLinkedNodes(for: name))
        return Array(unlinkedNodes)
            // Exclude the input node
            .filter({ $0.name != name })
            .sorted(by: { $0.name < $1.name })
    }

    func addNode(name: String) {
        backlinkEngine.addNode(name: name)
        backlinkRepo.save(model: backlinkEngine)
    }

    func deleteNode(name: String) {
        backlinkEngine.deleteNode(name: name)
        backlinkRepo.save(model: backlinkEngine)
    }

    func deleteNodes(names: [String]) {
        for name in names {
            backlinkEngine.deleteNode(name: name)
        }
        backlinkRepo.save(model: backlinkEngine)
    }

    func addLinkBetween(_ firstItemName: String, and secondItemName: String) {
        backlinkEngine.addLinkBetween(firstItemName, and: secondItemName)
        backlinkRepo.save(model: backlinkEngine)
    }

    func removeLinkBetween(_ firstItemName: String, and secondItemName: String) {
        backlinkEngine.removeLinkBetween(firstItemName, and: secondItemName)
        backlinkRepo.save(model: backlinkEngine)
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
