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

    @Binding var searchQuery: String

    @State var shouldGoToCanvasView = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Rectangle().fill(Color.UI.base5)
                graphView
            }
            .drawingGroup(opaque: true, colorMode: .extendedLinear)
            .gesture(getViewportDragGesture(viewportSize: geometry.size))
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
                getNavigationNodeView(for: node)
            }
        }
    }

    var edgesView: some View {
        ZStack {
            ForEach(viewModel.getEdges(), id: \.self) { edge in
                EdgeView(start: edge.source.position, end: edge.destination.position)
                    .stroke()
            }
        }
    }

    /// Returns a `View` that groups a `NodeView` alongside a `NavigationLink`.
    /// On long pressing the `NodeView`, the view will be navigated to the `MainView`
    /// Referenced from https://stackoverflow.com/a/62055596
    private func getNavigationNodeView(for node: BacklinkNode) -> some View {
        Group {
            // TODO: pass in the relevant canvas to mainView once storage has been implemented
            NavigationLink(destination: MainView()
                            .navigationBarHidden(true)
                            .navigationBarBackButtonHidden(true),
                           isActive: $shouldGoToCanvasView) {
                EmptyView()
            }

            NodeView(label: node.name, isHighlighted: doesInputMatchSearchQuery(input: node.name))
                .offset(x: node.position.x, y: node.position.y)
                .onLongPressGesture {
                    shouldGoToCanvasView = true
                }
        }
    }
}

// MARK: Gestures
extension GraphView {
    private func getViewportDragGesture(viewportSize: CGSize) -> some Gesture {
        DragGesture()
            .onChanged { value in
                // Dragging canvas instead of a node
                if viewModel.selectedNode == nil {
                    viewModel.hitTest(tapPos: value.startLocation,
                                      viewportSize: viewportSize,
                                      viewportZoomScale: zoomScale,
                                      viewportOriginOffset: originOffset)
                    self.dragOffset = value.translation
                } else {
                    viewModel.handleNodeDragChange(value, viewportZoomScale: zoomScale)
                }
            }
            .onEnded { value in
                // Dragged a canvas instead of a node
                if viewModel.selectedNode == nil {
                    self.dragOffset = .zero
                    self.originOffset += value.translation
                } else {
                    viewModel.handleNodeDragEnd(value, viewportZoomScale: zoomScale)
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

// MARK: Search bar helper functions

extension GraphView {
    private func doesInputMatchSearchQuery(input: String) -> Bool {
        if searchQuery.isEmpty {
            return false
        }
        return input.lowercased().contains(self.searchQuery.lowercased())
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView(searchQuery: .constant("Hello"))
    }
}
