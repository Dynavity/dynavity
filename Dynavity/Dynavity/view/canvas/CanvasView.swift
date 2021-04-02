import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CanvasElementMapView(viewModel: viewModel)
                    .scaleEffect(viewModel.scaleFactor)
                    .offset(viewModel.canvasViewportOffset)
                AnnotationCanvasView(viewModel: viewModel)
                    .disabled(viewModel.canvasMode == .selection)
            }
            .onAppear {
                viewModel.setCanvasViewport(size: geometry.size)
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(viewModel: CanvasViewModel())
    }
}
