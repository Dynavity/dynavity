import SwiftUI

struct RectangleUmlView: View {
    @StateObject private var viewModel: UmlElementViewModel

    init(umlElement: UmlElementProtocol) {
        self._viewModel = StateObject(wrappedValue: UmlElementViewModel(umlElement: umlElement))
    }

    struct Rectangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            return path
        }
    }

    var body: some View {
        ZStack {
            Rectangle().stroke(Color.black, lineWidth: viewModel.shapeBorderWidth)
            TextField("", text: $viewModel.umlElement.label)
                .multilineTextAlignment(.center)
        }.background(Color.white)
    }
}

struct RectangleUmlView_Previews: PreviewProvider {
    static var previews: some View {
        RectangleUmlView(umlElement: RectangleUmlElement(position: .zero))
    }
}
