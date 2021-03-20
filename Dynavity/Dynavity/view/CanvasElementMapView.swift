//
//  CanvasElementMapView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

struct CanvasElementMapView: View {
    @ObservedObject var viewModel: CanvasViewModel
    @Binding var scaleFactor: CGFloat

    var body: some View {
        ZStack {
            ForEach(viewModel.canvas.canvasElements, id: \.id) { element in
                // The group allows us to have common view modifiers.
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
                .addCardOverlay()
                .offset(x: element.position.x, y: element.position.y)
            }
        }
        .scaleEffect(scaleFactor)
    }
}

struct CanvasElementMapView_Previews: PreviewProvider {
    @ObservedObject static var viewModel = CanvasViewModel()
    @State static var scale: CGFloat = 1.0

    static var previews: some View {
        CanvasElementMapView(viewModel: viewModel, scaleFactor: $scale)
    }
}
