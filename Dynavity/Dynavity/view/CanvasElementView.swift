import SwiftUI

struct CanvasElementView: View {
    // TODO: Change this once actual canvas elemnts are created, arbitrary for now
    static let width = CGFloat(150)
    @State var element: CanvasElementProtocol

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: CanvasElementView.width,
                   height: CanvasElementView.width,
                   alignment: .center)
            .overlay(Text(element.text))
    }
}

struct CanvasElementView_Previews: PreviewProvider {
    static var previews: some View {
        let element = TestCanvasElement()
        CanvasElementView(element: element)
    }
}
