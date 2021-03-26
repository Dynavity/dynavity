import SwiftUI

struct GraphMapView: View {
    // TODO: Replace this with actual nodes aka canvases
    var nodes = (0...10).map({ "Node \($0)" })
    var edges = (0...100).map({ CGPoint(x: $0, y: $0) })

    var body: some View {
        ZStack {
            nodesView
            edgesView
        }
    }

    var nodesView: some View {
        ForEach(self.nodes, id: \.self) { node in
            NodeView(label: node)
        }
    }

    var edgesView: some View {
        ForEach(self.edges, id: \.self.x) { edge in
            EdgeView(end: edge)
                .stroke()
        }
    }
}

struct GraphMapView_Previews: PreviewProvider {
    static var previews: some View {
        GraphMapView()
    }
}
