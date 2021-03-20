import SwiftUI

struct SelectionOverlayView: View {
    var element: CanvasElementProtocol

    var body: some View {
        Rectangle()
            .fill(Color.green)
            .frame(width: element.width,
                   height: element.height,
                   alignment: .center)
    }
}

struct SelectionOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionOverlayView(element: TestCanvasElement())
    }
}
