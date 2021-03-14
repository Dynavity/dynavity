import SwiftUI

struct CanvasView: View {
    @ObservedObject var canvas: Canvas

    var body: some View {
        ZStack {
            Rectangle().fill(Color.blue)
            CanvasElementMapView(elements: $canvas.canvasElements)
        }
        Text("This is the canvas")
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let canvas = Canvas()

        CanvasView(canvas: canvas)
    }
}
