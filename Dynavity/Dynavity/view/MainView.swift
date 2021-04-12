import SwiftUI

struct MainView: View {
    @StateObject private var canvasViewModel: CanvasViewModel
    @State private var shouldShowMenu = false

    static let umlMenuButtonWidth: CGFloat = 25.0
    static let umlMenuButtonHeight: CGFloat = 40.0
    private let umlMenuButtonOffset: CGFloat = -5.0

    init(canvas: Canvas, annotationCanvas: AnnotationCanvas) {
        self._canvasViewModel = StateObject(wrappedValue: CanvasViewModel(canvas: canvas,
                                                                          annotationCanvas: annotationCanvas))
    }

    init() {
        self.init(canvas: Canvas(), annotationCanvas: AnnotationCanvas())
    }

    var sideMenu: some View {
        GeometryReader { geometry in
            if self.shouldShowMenu {
                SideMenuView()
                    .environmentObject(canvasViewModel)
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
        NavigationView {
            ZStack(alignment: .leading) {
                VStack(spacing: 0.0) {
                    ToolbarView(viewModel: canvasViewModel, shouldShowSideMenu: $shouldShowMenu)
                    Divider()
                    CanvasView(viewModel: canvasViewModel)
                }
                .disabled(self.shouldShowMenu)
                .overlay(shouldShowMenu ? translucentBlackOverlay : nil)

                if !canvasViewModel.shouldShowUmlMenu {
                    umlMenuButton
                }

                sideMenu
                umlMenu
            }
            .navigationBarHidden(true)
        }.navigationViewStyle(StackNavigationViewStyle())
    }

    var translucentBlackOverlay: some View {
        Rectangle()
            .fill(Color.black)
            .opacity(0.5)
            .gesture(dismissSideMenuTapGesture)
            .gesture(dismissSideMenuDragGesture)
    }
}

// MARK: Side Menu Related Gesture Handlers
extension MainView {
    private var dismissSideMenuDragGesture: some Gesture {
        DragGesture()
            .onEnded { value in
                handleSideMenuDrag(value)
            }
    }

    private var dismissSideMenuTapGesture: some Gesture {
        TapGesture()
            .onEnded {
                dismissSideMenu()
            }
    }

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
