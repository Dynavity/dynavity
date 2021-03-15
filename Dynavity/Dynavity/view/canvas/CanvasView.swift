import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel = CanvasViewModel()

    var body: some View {
        ZStack {
            Rectangle().fill(Color.blue)
            CanvasElementMapView(elements: $viewModel.canvas.canvasElements)
        }
        Text("This is the canvas")
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = CanvasViewModel()
        CanvasView(viewModel: viewModel)
    }
}
