//
//  DynavityApp.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 13/3/21.
//

import SwiftUI

@main
struct DynavityApp: App {
    @ObservedObject private var canvasViewModel = CanvasViewModel()
    @State var shouldShowMenu = false

    var body: some Scene {
        WindowGroup {
            GeometryReader { geometry in
                let dismissSideMenuTapGesture = TapGesture(count: 1)
                    .onEnded { _ in
                        handleSideMenuTap()
                    }

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
                        SideMenuView()
                            .frame(width: geometry.size.width / 3)
                            .transition(.move(edge: .trailing))
                            // Force the side menu to be drawn over everything else.
                            .zIndex(.infinity)
                    }
                }
                .gesture(dismissSideMenuDragGesture)
                .gesture(dismissSideMenuTapGesture)
            }
        }
    }

    var translucentBlackOverlay: some View {
        Rectangle().fill(Color.black).opacity(0.5)
    }
}

// MARK: SideMenu Related Gesture Handlers
extension DynavityApp {
    private func dismissSideMenu() {
        withAnimation {
            self.shouldShowMenu = false
        }
    }

    private func handleSideMenuTap() {
        guard shouldShowMenu else {
            return
        }

        dismissSideMenu()
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
