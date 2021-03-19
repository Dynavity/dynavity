import SwiftUI

struct MarkupTextBlockView: View {
    @ObservedObject var viewModel: MarkupTextBlockViewModel

    // TODO: This is set to "selected" for now.
    // The parent view containing this view should probably implement the logic for view selection.
    // Purpose of having this state is so that when the view is not selected, the text editor will not show
    @State var isViewSelected = true

    init(markupTextBlock: MarkupTextBlock) {
        self.viewModel = MarkupTextBlockViewModel(markupTextBlock: markupTextBlock)
    }

    var body: some View {
        HStack {
            if isViewSelected {
                TextEditor(text: $viewModel.markupTextBlock.text)
                    .font(.custom("Custom", size: viewModel.markupTextBlock.fontSize))
                Divider()
            }

            WebView(rawHtml: viewModel.rawHtml)
        }
        .padding()
    }
}

struct MarkupTextBlockView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupTextBlockView(markupTextBlock: MarkupTextBlock())
    }
}
