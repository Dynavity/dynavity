import SwiftUI

struct MarkupElementView: View {
    @StateObject private var viewModel: MarkupElementViewModel

    init(markupElement: MarkupElement) {
        self._viewModel = StateObject(wrappedValue:
                                        MarkupElementViewModel(markupElement: markupElement))
    }

    var body: some View {
        HStack {
            TextEditor(text: $viewModel.markupElement.text)
                .font(.system(size: viewModel.markupElement.fontSize))
            Divider()
            WebView(bodyHtmlContent: viewModel.rawHtml)
        }
        .padding()
    }
}

struct MarkupElementView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupElementView(markupElement: MarkupElement(position: .zero, markupType: .markdown))
    }
}
