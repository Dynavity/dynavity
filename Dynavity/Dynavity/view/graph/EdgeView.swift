import SwiftUI

struct EdgeView: Shape {
    let start: CGPoint
    let end: CGPoint

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}

struct EdgeView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeView(start: .zero, end: CGPoint(x: 50, y: 50))
            .stroke(lineWidth: 4)
    }
}
