//
//  CanvasElementView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementView: View {
    static let width = CGFloat(150) // arbitrary value for now
    @State var element: CanvasElementProtocol

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: CanvasElementView.width,
                   height: CanvasElementView.width,
                   alignment: .center)
            .overlay(Text(element.text))
    }
}

struct CanvasElementView_Previews: PreviewProvider {
    static var previews: some View {
        let element = TestCanvasElement()
        CanvasElementView(element: element)
    }
}
