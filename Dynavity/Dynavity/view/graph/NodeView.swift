import SwiftUI

struct NodeView: View {
    static let width = CGFloat(100)

    let label: String

    var body: some View {
        Ellipse()
            .fill(Color.UI.darkBlue.opacity(0.5))
            .overlay(Text(label)
                        .multilineTextAlignment(.center)
                        .padding())
            .frame(width: NodeView.width, height: NodeView.width, alignment: .center)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView(label: "AAAAA")
    }
}
