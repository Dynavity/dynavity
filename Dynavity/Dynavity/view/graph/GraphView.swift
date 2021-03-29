import SwiftUI

struct GraphView: View {
    private static let zoomScaleRange: ClosedRange<CGFloat> = 0.2...2.5

    @StateObject var viewModel = GraphMapViewModel()

    // For viewport dragging gesture
    @State var originOffset: CGPoint = .zero
    @State var dragOffset: CGSize = .zero

    // For viewport zooming
    @State var zoomScale: CGFloat = 1.0
    @State var previousZoomScale: CGFloat = 1.0

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Rectangle().fill(Color.UI.base5)
                graphView
            }
            .drawingGroup(opaque: true, colorMode: .extendedLinear)
            .gesture(viewportDragGesture)
            .gesture(viewportMagnificationGesture)
        }
    }

    var graphView: some View {
        Group {
            nodesView
                .zIndex(.infinity)
            edgesView
        }
        .scaleEffect(self.zoomScale)
        .offset(x: self.originOffset.x + self.dragOffset.width,
                y: self.originOffset.y + self.dragOffset.height)
        .animation(.easeIn)
    }

    var nodesView: some View {
        ZStack {
            ForEach(viewModel.getNodes(), id: \.id) { node in
                NodeView(label: node.name)
                    .position(x: node.position.x, y: node.position.y)
            }
        }
    }

    var edgesView: some View {
        ZStack {
            ForEach(viewModel.getEdges(), id: \.id) { edge in
                EdgeView(start: edge.source.position, end: edge.destination.position)
                    .stroke()
            }
        }
    }
}

// MARK: Gestures
extension GraphView {
    private var viewportDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                viewModel.hitTest(tapPos: value.startLocation,
                                  viewportZoomScale: zoomScale,
                                  viewportOriginOffset: originOffset)

                if viewModel.selectedNode != nil {
                    viewModel.moveSelectedNode(by: value.translation)
                } else {
                    self.dragOffset = value.translation
                }
            }
            .onEnded { value in
                if viewModel.selectedNode != nil {
                    viewModel.selectedNode = nil
                } else {
                    self.dragOffset = .zero
                    self.originOffset += value.translation
                }
            }
    }

    private var viewportMagnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let delta = value / self.previousZoomScale
                self.previousZoomScale = value
                let newScale = self.zoomScale * delta

                self.zoomScale = newScale.clamped(to: GraphView.zoomScaleRange)
            }
            .onEnded { _ in
                self.previousZoomScale = 1.0
            }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
