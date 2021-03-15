import SwiftUI

struct MarkupView: View {
    @ObservedObject var viewModel = MarkupViewModel()

    var body: some View {
        HStack {
            TextEditor(text: $viewModel.markupTextBlock.rawText)
            Divider()
            WebView(rawHtml: viewModel.markupTextBlock.toHtml())
        }.addCardOverlay().padding()
    }
}

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView()
    }
}
