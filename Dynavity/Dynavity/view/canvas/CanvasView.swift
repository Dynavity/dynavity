import SwiftUI

struct CanvasView: View {
    @ObservedObject var canvas: Canvas

    var body: some View {
        Text("This is the canvas")
    }
}

struct CanvasView_Previews: PreviewProvider {
    static var previews: some View {
        let canvas = Canvas()

        CanvasView(canvas: canvas)
    }
}
