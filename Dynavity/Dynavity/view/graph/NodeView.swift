import SwiftUI

struct NodeView: View {
    static let width = CGFloat(100)

    var body: some View {
        Ellipse()
            .fill(Color.green)
            .overlay(Text("LOOOOOOOOOOOOOOOOOOOOOOOOONG TEXT")
                        .multilineTextAlignment(.center)
                        .padding())
            .frame(width: NodeView.width, height: NodeView.width, alignment: .center)
    }
}

struct NodeView_Previews: PreviewProvider {
    static var previews: some View {
        NodeView()
    }
}
