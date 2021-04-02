//
//  DynavityApp.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 13/3/21.
//

import SwiftUI

@main
struct DynavityApp: App {
    @StateObject var graphMapViewModel = GraphMapViewModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(graphMapViewModel)
        }
    }
}
