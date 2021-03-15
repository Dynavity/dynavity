//
//  SurfaceView.swift
//  Dynavity
//
//  Created by Hans Sebastian Tirtaputra on 15/3/21.
//

import SwiftUI

/**
 `SurfaceView` keeps track of the interactions from the user with the canvas.
 */
struct SurfaceView: View {
    @ObservedObject var viewModel = CanvasViewModel()

    // For drag interactions
    @State var portalPosition: CGPoint = .zero
    @State var dragOffset: CGSize = .zero
    @State var isDragging: Bool = false
    @State var isDraggingCanvas: Bool = false

    // For zoom interactions
    @State var zoomScale: CGFloat = 1.0
    @State var initialZoomScale: CGFloat?
    @State var initialPortalPosition: CGPoint?

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CanvasView(viewModel: viewModel)
                    .scaleEffect(zoomScale)
                    .offset(x: portalPosition.x + dragOffset.width,
                            y: portalPosition.y + dragOffset.height)
                    .animation(.easeIn)
            }
            .gesture(DragGesture()
                        .onChanged { value in
                            handleDragChange(value, containerSize: geometry.size)
                        }
                        .onEnded { value in
                            handleDragEnd(value)
                        })

        }
    }

}

struct SurfaceView_Previews: PreviewProvider {
    static var previews: some View {
        SurfaceView()
    }
}

extension SurfaceView {
    func handleDragChange(_ value: DragGesture.Value, containerSize: CGSize) {
        isDragging = true
        // TODO: Add logic to determine dragging canvas or canvas element
        isDraggingCanvas = true

        if isDraggingCanvas {
            dragOffset = value.translation
        } else {
            // TODO: Add handle canvas element translation
        }
    }

    func handleDragEnd(_ value: DragGesture.Value) {
        isDragging = false
        dragOffset = .zero

        if isDraggingCanvas {
            portalPosition = CGPoint(
                x: portalPosition.x + value.translation.width,
                y: portalPosition.y + value.translation.height
            )
        }
    }
}
