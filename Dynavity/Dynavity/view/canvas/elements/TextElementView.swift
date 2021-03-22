import SwiftUI

struct TextElementView: View {
    @StateObject private var viewModel: TextElementViewModel

    init(textBlock: TextElement) {
        self._viewModel = StateObject(wrappedValue: TextElementViewModel(textBlock: textBlock))
    }

    var body: some View {
        TextEditor(text: $viewModel.textBlock.text)
            .font(.custom("Custom", size: viewModel.textBlock.fontSize))
            .padding()
    }
}

struct TextBlockView_Previews: PreviewProvider {
    static var previews: some View {
        TextElementView(textBlock: TextElement(position: .zero))
    }
}
