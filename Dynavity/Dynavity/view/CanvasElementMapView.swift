//
//  CanvasElementMapView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementMapView: View {
    @Binding var elements: [CanvasElementProtocol]

    var body: some View {
        ZStack {
            ForEach(elements, id: \.id) { element in
                // The group allows us to have common view modifiers.
                Group {
                    switch element {
                    case let imageCanvasElement as ImageCanvasElement:
                        ImageCanvasElementView(imageCanvasElement: imageCanvasElement)
                    case _ as TextBlock:
                        TextBlockView()
                    default:
                        CanvasElementView(element: element)
                    }

                }
                .addCardOverlay()
                .offset(x: element.position.x, y: element.position.y)
            }
        }
    }
}

struct CanvasElementMapView_Previews: PreviewProvider {
    static let testElement1 = TestCanvasElement(position: CGPoint(x: -150, y: -150), text: "Test1")
    static let testElement2 = TestCanvasElement(position: CGPoint(x: 150, y: 150), text: "Test2")
    @State static var elements: [CanvasElementProtocol] = [testElement1, testElement2]

    static var previews: some View {
        CanvasElementMapView(elements: $elements)
    }
}
