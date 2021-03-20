//
//  CanvasElementMapView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.moveSelectedCanvasElement(by: value.translation)
            }
    }

    private func transformToView(element: CanvasElementProtocol) -> some View {
        Group {
            switch element {
            case let imageCanvasElement as ImageCanvasElement:
                ImageCanvasElementView(imageCanvasElement: imageCanvasElement)
            case let pdfCanvasElement as PDFCanvasElement:
                PDFCanvasElementView(pdfCanvasElement: pdfCanvasElement)
            case let textBlock as TextBlock:
                TextBlockView(textBlock: textBlock)
            case let markupTextBlock as MarkupTextBlock:
                MarkupTextBlockView(markupTextBlock: markupTextBlock)
            default:
                CanvasElementView(element: element)
            }
        }
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.canvas.canvasElements, id: \.id) { element in
                ZStack {
                    transformToView(element: element)
                        .frame(width: element.width, height: element.height)
                        .addCardOverlay()
                        .onTapGesture {
                            viewModel.select(canvasElement: element)
                        }
                        .gesture(dragGesture)
                    if viewModel.selectedCanvasElementId == element.id {
                        SelectionOverlayView(element: element)
                            .allowsHitTesting(false)
                    }
                }
                .offset(x: element.position.x, y: element.position.y)
            }
        }
    }
}

struct CanvasElementMapView_Previews: PreviewProvider {
    @ObservedObject static var viewModel = CanvasViewModel()
    @State static var scale: CGFloat = 1.0

    static var previews: some View {
        CanvasElementMapView(viewModel: viewModel)
    }
}
