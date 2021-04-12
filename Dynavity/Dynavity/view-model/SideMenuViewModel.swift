import SwiftUI

class SideMenuViewModel: ObservableObject {
    @Published var selectedLinkedNodes: [BacklinkNode] = []
    @Published var selectedUnlinkedNodes: [BacklinkNode] = []

    func publishCanvas(canvasViewModel: CanvasViewModel) {
        canvasViewModel.canvas = OnlineCanvas(canvas: canvasViewModel.canvas)
        // TODO delete local copy and save online copy

    }
}
