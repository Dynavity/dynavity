import SwiftUI

struct CanvasElementView: View {
    @State var element: CanvasElementProtocol

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: element.width,
                   height: element.width,
                   alignment: .center)
    }
}

struct CanvasElementView_Previews: PreviewProvider {
    static var previews: some View {
        let element = TestCanvasElement()
        CanvasElementView(element: element)
    }
}
