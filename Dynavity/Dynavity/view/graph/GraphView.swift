import SwiftUI

struct GraphView: View {
    @StateObject var viewModel = GraphMapViewModel()

    var body: some View {
        ZStack {
            nodesView
            edgesView
        }
    }

    var nodesView: some View {
        ForEach(viewModel.getNodes(), id: \.id) { node in
            NodeView(label: node.name)
                .offset(x: node.position.x, y: node.position.y)
        }
    }

    var edgesView: some View {
        ForEach(viewModel.getEdges(), id: \.id) { edge in
            EdgeView(start: edge.source.position, end: edge.destination.position)
                .stroke()
        }
    }
}

struct GraphView_Previews: PreviewProvider {
    static var previews: some View {
        GraphView()
    }
}
