import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    private func calculateOffsetX(width: CGFloat) -> CGFloat {
        viewModel.canvasViewWidth = width
        return -(viewModel.canvasOrigin.x + viewModel.canvasCenterOffsetX)
            + width / 2.0 * (viewModel.scaleFactor - 1.0)
    }

    private func calculateOffsetY(height: CGFloat) -> CGFloat {
        viewModel.canvasViewHeight = height
        return -(viewModel.canvasOrigin.y + viewModel.canvasCenterOffsetY)
            + height / 2.0 * (viewModel.scaleFactor - 1.0)
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CanvasElementMapView(viewModel: viewModel)
                    .scaleEffect(viewModel.scaleFactor)
                    .offset(
                        x: calculateOffsetX(width: geometry.size.width),
                        y: calculateOffsetY(height: geometry.size.height)
                    )
                AnnotationCanvasView(viewModel: viewModel)
                    .disabled(viewModel.canvasMode == .selection)
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(viewModel: CanvasViewModel())
    }
}
