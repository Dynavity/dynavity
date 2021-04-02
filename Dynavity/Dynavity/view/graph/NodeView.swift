import SwiftUI

struct NodeView: View {
    static let radius: CGFloat = 40
    private static var diameter: CGFloat {
        radius * 2
    }
    private static let fontSize: CGFloat = 10.0

    private static let highlightedNodeColor = Color.UI.green.opacity(0.8)
    private static let defaultNodeColor = Color.UI.blue.opacity(0.8)

    let label: String
    let isHighlighted: Bool

    var body: some View {
        Ellipse()
            .fill(isHighlighted ? NodeView.highlightedNodeColor : NodeView.defaultNodeColor)
            .overlay(Text(label)
                        .font(.system(size: NodeView.fontSize))
                        .multilineTextAlignment(.center)
                        .padding())
            .frame(width: NodeView.diameter, height: NodeView.diameter, alignment: .center)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(label: "AAAAA", isHighlighted: true)
    }
}
