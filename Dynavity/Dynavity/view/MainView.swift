import SwiftUI

struct MainView: View {
    @ObservedObject private var canvasViewModel = CanvasViewModel()
    @State private var shouldShowMenu = false

    var body: some View {
        GeometryReader { geometry in
            let dismissSideMenuDragGesture = DragGesture()
                .onEnded { value in
                    handleSideMenuDrag(value)
                }

            ZStack(alignment: .trailing) {
                VStack(spacing: 0.0) {
                    ToolbarView(viewModel: canvasViewModel, shouldShowSideMenu: $shouldShowMenu)
                    Divider()
                    CanvasView(viewModel: canvasViewModel)
                }
                .overlay(shouldShowMenu ? translucentBlackOverlay : nil)
                .disabled(self.shouldShowMenu)

                if self.shouldShowMenu {
                    SideMenuView(canvasName: $canvasViewModel.canvas.name)
                        .frame(width: geometry.size.width / 3)
                        .transition(.move(edge: .trailing))
                        // Force the side menu to be drawn over everything else.
                        .zIndex(.infinity)
                }
            }.gesture(shouldShowMenu ? dismissSideMenuDragGesture : nil)
        }
    }

    var translucentBlackOverlay: some View {
        Rectangle().fill(Color.black).opacity(0.5)
    }
}

// MARK: Side Menu Related Gesture Handlers
extension MainView {
    private func dismissSideMenu() {
        withAnimation {
            self.shouldShowMenu = false
        }
    }

    private func handleSideMenuDrag(_ value: DragGesture.Value) {
        guard shouldShowMenu else {
            return
        }

        // When sliding right, hide menu
        if value.translation.width > 50 {
            dismissSideMenu()
        }

    }

}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
