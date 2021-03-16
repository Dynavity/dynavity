import SwiftUI

struct MarkupView: View {
    @ObservedObject var viewModel = MarkupViewModel()

    // TODO: This is set to "selected" for now.
    // The parent view containing this view should probably implement the logic for view selection.
    // Purpose of having this state is because when the view is not selected, the text editor should not show
    // (except for when it's displaying plain text)
    @State var isViewSelected: Bool = true

    var body: some View {
        HStack {
            let isPlainText = viewModel.markupTextBlock.markupType == .plaintext

            if isViewSelected || isPlainText {
                TextEditor(text: $viewModel.markupTextBlock.text)
                    .font(.custom("Custom", size: viewModel.markupTextBlock.fontSize))
            }

            // Show divider only when TextEditor and WebView are both shown
            if isViewSelected && !isPlainText {
                Divider()
            }

            if !isPlainText {
                WebView(rawHtml: viewModel.rawHtml)
            }
        }
        .addCardOverlay()
        .padding()
    }
}

struct MarkupView_Previews: PreviewProvider {
    static var previews: some View {
        MarkupView()
    }
}
