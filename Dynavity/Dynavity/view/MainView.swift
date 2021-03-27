import SwiftUI

struct MainView: View {
    @ObservedObject private var canvasViewModel = CanvasViewModel()
    @State private var shouldShowMenu = false

    static let umlMenuButtonWidth: CGFloat = 25.0
    static let umlMenuButtonHeight: CGFloat = 40.0
    private let umlMenuButtonOffset: CGFloat = -5.0

    var sideMenu: some View {
        GeometryReader { geometry in
            if self.shouldShowMenu {
                SideMenuView(canvasName: $canvasViewModel.canvas.name)
                    .frame(width: geometry.size.width / 3)
                    .offset(CGSize(width: geometry.size.width * (2 / 3), height: 0))
                    .transition(.move(edge: .trailing))
                    // Force the side menu to be drawn over everything else.
                    .zIndex(.infinity)
            }
        }
    }

    var umlMenu: some View {
        GeometryReader { geometry in
            if canvasViewModel.shouldShowUmlMenu {
                UmlSideMenuView(viewModel: canvasViewModel)
                    .frame(width: geometry.size.width / 3)
                    .transition(.move(edge: .leading))
                    // Force the side menu to be drawn over everything else.
                    .zIndex(.infinity)
            }
        }
    }

    var umlMenuButton: some View {
        Button(action: {
            canvasViewModel.showUmlMenu()
        }) {
            Image(systemName: "arrow.right.square").resizable()
        }
        .frame(width: MainView.umlMenuButtonWidth, height: MainView.umlMenuButtonHeight)
        .offset(x: umlMenuButtonOffset, y: 0)
    }

    var body: some View {
        let dismissSideMenuDragGesture = DragGesture()
            .onEnded { value in
                handleSideMenuDrag(value)
            }

        ZStack(alignment: .leading) {
            VStack(spacing: 0.0) {
                ToolbarView(viewModel: canvasViewModel, shouldShowSideMenu: $shouldShowMenu)
                Divider()
                CanvasView(viewModel: canvasViewModel)
            }
            .overlay(shouldShowMenu ? translucentBlackOverlay : nil)
            .disabled(self.shouldShowMenu)

            if !canvasViewModel.shouldShowUmlMenu {
                umlMenuButton
            }

            sideMenu.gesture(shouldShowMenu ? dismissSideMenuDragGesture : nil)
            umlMenu
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
