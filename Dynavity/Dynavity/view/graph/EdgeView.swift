import SwiftUI

struct EdgeView: Shape {
    let start = CGPoint(x: Int.random(in: 0...100), y: Int.random(in: 0...100))
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
        EdgeView(end: CGPoint(x: 10, y: 10))
            .stroke(lineWidth: 4)
    }
}
