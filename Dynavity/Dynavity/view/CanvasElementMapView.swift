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
            case let imageCanvasElement as ImageElement:
                ImageElementView(imageCanvasElement: imageCanvasElement)
            case let pdfCanvasElement as PDFElement:
                PDFElementView(pdfCanvasElement: pdfCanvasElement)
            case let textBlock as TextElement:
                TextElementView(textBlock: textBlock)
            case let codeSnippet as CodeElement:
                CodeElementView(codeSnippet: codeSnippet)
            case let markupTextBlock as MarkupElement:
                MarkupElementView(markupTextBlock: markupTextBlock)
            default:
                TestCanvasElementView(element: element)
            }
        }
    }

    private func isSelected(_ element: CanvasElementProtocol) -> Bool {
        viewModel.selectedCanvasElementId == element.id
    }

    var body: some View {
        ZStack {
            ForEach(viewModel.canvas.canvasElements, id: \.id) { element in
                transformToView(element: element)
                    .frame(width: element.width, height: element.height)
                    .addCardOverlay()
                    .onTapGesture {
                        viewModel.select(canvasElement: element)
                    }
                    .gesture(isSelected(element) ? dragGesture : nil)
                    .overlay(isSelected(element) ? SelectionOverlayView(element: element, viewModel: viewModel) : nil)
                    .rotationEffect(.radians(element.rotation))
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
