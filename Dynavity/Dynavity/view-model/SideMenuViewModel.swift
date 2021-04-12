import SwiftUI

class SideMenuViewModel: ObservableObject {
    @Published var selectedLinkedNodes: [BacklinkNode] = []
    @Published var selectedUnlinkedNodes: [BacklinkNode] = []

    func publishCanvas(canvasViewModel: CanvasViewModel) {
        canvasViewModel.publishCanvas()
    }
}
