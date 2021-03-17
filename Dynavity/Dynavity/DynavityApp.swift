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

    var body: some Scene {
        WindowGroup {
            VStack(spacing: 0.0) {
                ToolbarView(viewModel: canvasViewModel)
                Divider()
                CanvasView(viewModel: canvasViewModel)
            }
        }
    }
}
