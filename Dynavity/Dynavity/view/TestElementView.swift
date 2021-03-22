import SwiftUI

struct TestElementView: View {
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

struct TestElementView_Previews: PreviewProvider {
    static var previews: some View {
        let element = TestElement()
        TestElementView(element: element)
    }
}
