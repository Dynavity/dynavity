import SwiftUI

struct PlainTextElementView: View {
    @StateObject private var viewModel: PlainTextElementViewModel

    init(plainTextElement: PlainTextElement) {
        self._viewModel = StateObject(wrappedValue: PlainTextElementViewModel(plainTextElement: plainTextElement))
    }

    var body: some View {
        TextEditor(text: $viewModel.plainTextElement.text)
            .font(.custom("Custom", size: viewModel.plainTextElement.fontSize))
            .padding()
    }
}

struct TextElementView_Previews: PreviewProvider {
    static var previews: some View {
        PlainTextElementView(plainTextElement: PlainTextElement(position: .zero))
    }
}
