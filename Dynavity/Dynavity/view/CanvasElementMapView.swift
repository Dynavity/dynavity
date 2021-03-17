//
//  CanvasElementMapView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject private var viewModel: CanvasViewModel
    // Nested `@ObservedObject`s do not trigger updates, so we need to extract `canvas` out.
    @ObservedObject private var canvas: Canvas

    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
        self.canvas = viewModel.canvas
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.moveSelectedCanvasElement(to: value.location)
            }
    }

    var body: some View {
        ZStack {
            ForEach(canvas.canvasElements, id: \.id) { element in
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
                .gesture(dragGesture)
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
