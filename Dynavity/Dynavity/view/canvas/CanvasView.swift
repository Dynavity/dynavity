import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                AnnotationCanvasView(viewModel: viewModel, isDrawingDisabled: true)
                    .onTapGesture {
                        viewModel.unselectCanvasElement()
                        self.closeKeyboard()
                    }
                CanvasElementMapView(viewModel: viewModel)
                    .scaleEffect(viewModel.scaleFactor)
                    .offset(viewModel.canvasViewportOffset)
                AnnotationCanvasView(viewModel: viewModel)
                    .disabled(viewModel.canvasMode == .selection)
            }
            .onAppear {
                viewModel.setCanvasViewport(size: geometry.size)
            }
            .onReceive(viewModel.autoSavePublisher, perform: { _ in
                viewModel.saveCanvas()
            })
            .onDisappear {
                viewModel.saveCanvas()
            }
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(viewModel: CanvasViewModel())
    }
}
