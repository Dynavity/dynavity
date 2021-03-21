import SwiftUI

struct TestCanvasElementView: View {
    @Binding var element: CanvasElementProtocol

    init(element: CanvasElementProtocol) {
        self._element = Binding.constant(element)
    }

    var body: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: element.width,
                   height: element.height,
                   alignment: .center)
    }
}

struct TestCanvasElementView_Previews: PreviewProvider {
    static var previews: some View {
        let element = TestCanvasElement()
        TestCanvasElementView(element: element)
    }
}
