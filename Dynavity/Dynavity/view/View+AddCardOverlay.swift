//
//  View+AddCardOverlay.swift
//  Dynavity
//
//  Created by Sebastian on 14/3/21.
//

import SwiftUI

extension View {
    func addCardOverlay() -> some View {
        self.background(Rectangle().fill(Color.white).shadow(radius: 8))
    }
}
