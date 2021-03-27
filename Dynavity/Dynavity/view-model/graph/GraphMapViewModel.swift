import CoreGraphics
import Combine

class GraphMapViewModel: ObservableObject {
    @Published var backlinkEngine = BacklinkEngine()

    init() {
        initialiseBacklinkEngine()
    }

    private func initialiseBacklinkEngine() {
        // Load some files containing edges and stuff
        // Build the graph
    }

    func getNodes() -> [BacklinkNode] {
        backlinkEngine.nodes
    }

    func getEdges() -> [BacklinkEdge] {
        backlinkEngine.edges
    }
}
