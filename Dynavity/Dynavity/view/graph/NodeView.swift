import SwiftUI

struct NodeView: View {
    private static let size = CGSize(width: 80, height: 80)
    private static let fontSize: CGFloat = 10.0

    let label: String

    var body: some View {
        Ellipse()
            .fill(Color.UI.darkBlue.opacity(0.5))
            .overlay(Text(label)
                        .font(.system(size: NodeView.fontSize))
                        .multilineTextAlignment(.center)
                        .padding())
            .frame(width: NodeView.size.width, height: NodeView.size.height, alignment: .center)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(label: "AAAAA")
    }
}
