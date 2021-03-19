//
//  CanvasElementMapView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject private var viewModel: CanvasViewModel

    init(viewModel: CanvasViewModel) {
        self.viewModel = viewModel
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.moveSelectedCanvasElement(to: value.location)
            }
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.canvas.canvasElements, id: \.id) { element in
                // The group allows us to have common view modifiers.
                Group {
                    switch element {
                    case let imageCanvasElement as ImageCanvasElement:
                        ImageCanvasElementView(imageCanvasElement: imageCanvasElement)
                    case let textBlock as TextBlock:
                        TextBlockView(textBlock: textBlock)
                    case let markupTextBlock as MarkupTextBlock:
                        MarkupTextBlockView(markupTextBlock: markupTextBlock)
                    default:
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
