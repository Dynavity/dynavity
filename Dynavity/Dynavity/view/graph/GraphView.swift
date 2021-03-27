import SwiftUI

struct GraphView: View {
    @StateObject var viewModel = GraphMapViewModel()

    // For viewport dragging gesture
    @State var originOffset: CGPoint = .zero
    @State var dragOffset: CGSize = .zero

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Rectangle().fill(Color.UI.base5)
                graphView
            }
            .drawingGroup(opaque: true, colorMode: .extendedLinear)
            .gesture(viewportDragGesture)
        }
    }

    var graphView: some View {
        Group {
            nodesView
                .zIndex(.infinity)
            edgesView
        }
        .offset(x: self.originOffset.x + self.dragOffset.width,
                y: self.originOffset.y + self.dragOffset.height)
        .animation(.easeIn)
    }

    var nodesView: some View {
        ForEach(viewModel.getNodes(), id: \.id) { node in
            NodeView(label: node.name)
                .position(x: node.position.x, y: node.position.y)
        }
    }

    var edgesView: some View {
        ForEach(viewModel.getEdges(), id: \.id) { edge in
            EdgeView(start: edge.source.position, end: edge.destination.position)
                .stroke()
        }
    }
}

// MARK: Gestures
extension GraphView {
    var viewportDragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                dragOffset = value.translation
            }
            .onEnded { value in
                dragOffset = .zero
                originOffset += value.translation
            }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
