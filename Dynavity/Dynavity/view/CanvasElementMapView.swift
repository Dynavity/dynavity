//
//  CanvasElementMapView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementMapView: View {
    var viewModel: CanvasViewModel

    var body: some View {
        ZStack {
            ForEach(viewModel.canvas.canvasElements, id: \.id) { element in
                // The group allows us to have common view modifiers.
                Group {
                    if let imageCanvasElement = element as? ImageCanvasElement {
                        ImageCanvasElementView(imageCanvasElement: imageCanvasElement)
                    } else {
                        CanvasElementView(element: element)
                    }
                }
                .addCardOverlay()
                .onTapGesture {
                    viewModel.select(canvasElement: element)
                }
                .offset(x: element.position.x, y: element.position.y)
            }
        }
    }
}

struct CanvasElementMapView_Previews: PreviewProvider {
    @State static var viewModel = CanvasViewModel(canvas: Canvas())

    static var previews: some View {
        CanvasElementMapView(viewModel: viewModel)
    }
}
