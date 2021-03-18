import SwiftUI

struct TextBlockView: View {
    @ObservedObject var viewModel: TextBlockViewModel

    init(textBlock: TextBlock) {
        self.viewModel = TextBlockViewModel(textBlock: textBlock)
    }

    var body: some View {
        TextEditor(text: $viewModel.textBlock.text)
            .font(.custom("Custom", size: viewModel.textBlock.fontSize))
            .padding()
    }
}

struct TextBlockView_Previews: PreviewProvider {
    static var previews: some View {
        TextBlockView(textBlock: TextBlock())
    }
}
