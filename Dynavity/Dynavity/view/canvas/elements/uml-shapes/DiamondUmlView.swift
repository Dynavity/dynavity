import SwiftUI

struct DiamondUmlView: View {
    @StateObject private var viewModel: UmlElementViewModel

    init(umlElement: UmlElementProtocol) {
        self._viewModel = StateObject(wrappedValue: UmlElementViewModel(umlElement: umlElement))
    }

    struct Diamond: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
            return path
        }
    }

    var body: some View {
        ZStack {
            Diamond().stroke(Color.black, lineWidth: viewModel.shapeBorderWidth)
            TextField("", text: $viewModel.umlElement.label)
                .multilineTextAlignment(.center)
        }
    }
}

struct DiamondUmlView_Previews: PreviewProvider {
    static var previews: some View {
        DiamondUmlView(umlElement: DiamondUmlElement(position: .zero))
    }
}
