import SwiftUI

struct MarkupElementView: View {
    @StateObject private var viewModel: MarkupElementViewModel

    // TODO: This is set to "selected" for now.
    // The parent view containing this view should probably implement the logic for view selection.
    // Purpose of having this state is so that when the view is not selected, the text editor will not show
    @State private var isViewSelected = true

    init(markupElement: MarkupElement) {
        self._viewModel = StateObject(wrappedValue:
                                        MarkupElementViewModel(markupElement: markupElement))
    }

    var body: some View {
        HStack {
            if isViewSelected {
                TextEditor(text: $viewModel.markupElement.text)
                    .font(.custom("Custom", size: viewModel.markupElement.fontSize))
                Divider()
            }

            WebView(rawHtml: viewModel.rawHtml)
        }
        .padding()
    }
}

struct MarkupElementView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupElementView(markupElement: MarkupElement(position: .zero, markupType: .markdown))
    }
}
