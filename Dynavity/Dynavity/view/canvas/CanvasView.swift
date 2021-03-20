import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    var body: some View {
        ZStack {
            AnnotationCanvasView(viewModel: viewModel)
            CanvasElementMapView(viewModel: viewModel)
                .scaleEffect(viewModel.scaleFactor)
                .offset(
                    x: -(viewModel.canvasOrigin.x + viewModel.canvasCenterOffsetX),
                    y: -(viewModel.canvasOrigin.y + viewModel.canvasCenterOffsetY)
                )
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(viewModel: CanvasViewModel())
    }
}
