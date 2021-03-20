import SwiftUI

struct CanvasView: View {
    @ObservedObject var viewModel: CanvasViewModel

    var body: some View {
        ZStack {
            AnnotationCanvasView(viewModel: viewModel)
            CanvasElementMapView(viewModel: viewModel)
                .offset(x: -250_000, y: -250_000)
        }
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        CanvasView(viewModel: CanvasViewModel())
    }
}
