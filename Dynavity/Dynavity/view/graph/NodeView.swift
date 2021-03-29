import SwiftUI

struct NodeView: View {
    static let radius: CGFloat = 40
    private static var diameter: CGFloat {
        radius * 2
    }

    private static let fontSize: CGFloat = 10.0

    let label: String

    var body: some View {
        Ellipse()
            .fill(Color.UI.darkBlue.opacity(0.5))
            .overlay(Text(label)
                        .font(.system(size: NodeView.fontSize))
                        .multilineTextAlignment(.center)
                        .padding())
            .frame(width: NodeView.diameter, height: NodeView.diameter, alignment: .center)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(label: "AAAAA")
    }
}
