//
//  DynavityApp.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 13/3/21.
//

import SwiftUI

@main
struct DynavityApp: App {
    var body: some Scene {
        WindowGroup {
            VStack {
                ToolbarView()
                CanvasView()
            }
        }
    }
}
