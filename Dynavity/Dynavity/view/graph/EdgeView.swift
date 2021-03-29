import SwiftUI

struct EdgeView: Shape {
    var start: CGPoint
    var end: CGPoint

    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: start.translateBy(x: rect.width / 2, y: rect.height / 2))
            p.addLine(to: end.translateBy(x: rect.width / 2, y: rect.height / 2))
        }
    }

    var animatableData: AnimatablePair<CGPoint.AnimatableData, CGPoint.AnimatableData> {
        get {
            AnimatablePair(start.animatableData, end.animatableData)
        }
        set {
            (start.animatableData, end.animatableData) = (newValue.first, newValue.second)
        }
    }
}

struct EdgeView_Previews: PreviewProvider {
    static var previews: some View {
        EdgeView(start: .zero, end: CGPoint(x: 50, y: 50))
            .stroke(lineWidth: 4)
    }
}
