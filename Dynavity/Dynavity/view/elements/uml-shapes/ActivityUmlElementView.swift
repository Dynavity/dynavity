import SwiftUI

struct ActivityUmlElementView: View {
    @StateObject private var viewModel: UmlElementViewModel
    private let backgroundOpacity: Double = 0.001

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
            if viewModel.umlElement.umlShape == .rectangle {
                Rectangle().stroke(Color.black, lineWidth: viewModel.shapeBorderWidth)
            } else {
                Diamond().stroke(Color.black, lineWidth: viewModel.shapeBorderWidth)
            }
            TextField("", text: $viewModel.umlElement.label)
                .multilineTextAlignment(.center)
        }.background(Color.white.opacity(backgroundOpacity))
    }
}

struct ActivityUmlView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityUmlElementView(umlElement: ActivityUmlElement(position: .zero, shape: .rectangle))
    }
}
