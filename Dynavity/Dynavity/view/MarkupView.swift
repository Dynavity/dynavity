import SwiftUI

struct MarkupView: View {
    @ObservedObject var viewModel = MarkupViewModel()

    var body: some View {
        HStack {
            TextEditor(text: $viewModel.markupTextBlock.text)
                .font(.custom("Custom", size: viewModel.markupTextBlock.fontSize))
            Divider()
            WebView(rawHtml: viewModel.rawHtml)
        }.addCardOverlay().padding()
    }
}

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView()
    }
}
